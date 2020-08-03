package main

import (
	"context"
	"errors"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"

	"github.com/symopsio/sym-okta-golang/pkg/config"
	"github.com/symopsio/sym-okta-golang/pkg/group"
	"github.com/symopsio/sym-okta-golang/pkg/role"
	"github.com/symopsio/types/go/messages"
)

type functionType int
type roleAssignmentStrategy int

const (
	approve functionType = iota
	expire
)

const (
	individual roleAssignmentStrategy = iota
	byGroup
)

var approvalHandlers = map[roleAssignmentStrategy]func(context.Context, *config.SymConfig, *messages.Approval) (*messages.ApprovalResponse, error){
	individual: role.AssignUserToRole,
	byGroup:    group.AddUserToGroup,
}

var expirationHandlers = map[roleAssignmentStrategy]func(context.Context, *config.SymConfig, *messages.Expiration) (*messages.ExpirationResponse, error){
	individual: role.UnassignUserFromRole,
	byGroup:    group.RemoveUserFromGroup,
}

var cfg *config.SymConfig
var funcType functionType
var strategy roleAssignmentStrategy

func init() {
	var err error
	cfg, err = config.InitSymConfigFromEnvironment()
	if err != nil {
		panic(err)
	}

	funcType, err = getFunctionType()
	if err != nil {
		panic(err)
	}

	strategy, err = getRoleAssignmentStrategy()
	if err != nil {
		panic(err)
	}
}

func endsWith(lhs string, rhs string) bool {
	last := strings.LastIndex(lhs, rhs)
	return last >= 0 && last+len(rhs) == len(lhs)
}

func getFunctionType() (functionType, error) {
	name := lambdacontext.FunctionName
	switch {
	case endsWith(name, "-approve"):
		return approve, nil
	case endsWith(name, "-expire"):
		return expire, nil
	default:
		return -1, errors.New("function name should end with -approve or -expire")
	}
}

func getRoleAssignmentStrategy() (roleAssignmentStrategy, error) {
	switch strategy := os.Getenv("ROLE_ASSIGNMENT_STRATEGY"); strategy {
	case "individual":
		return individual, nil
	case "group":
		return byGroup, nil
	default:
		return -1, errors.New("role assignment strategy should be individual or group")
	}
}

func main() {
	switch funcType {
	case approve:
		approvalHandler := approvalHandlers[strategy]
		lambda.Start(func(ctx context.Context, approval *messages.Approval) (*messages.ApprovalResponse, error) {
			return approvalHandler(ctx, cfg, approval)
		})
	case expire:
		expirationHandler := expirationHandlers[strategy]
		lambda.Start(func(ctx context.Context, expiration *messages.Expiration) (*messages.ExpirationResponse, error) {
			return expirationHandler(ctx, cfg, expiration)
		})
	}
}
