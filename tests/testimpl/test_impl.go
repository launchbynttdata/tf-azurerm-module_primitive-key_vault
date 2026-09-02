package common

import (
	"context"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestComposableKeyVault(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	rgId := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "resource_group_id")
	rgName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "resource_group_name")
	keyVaultName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "key_vault_name")
	keyVaultId := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "key_vault_id")

	t.Run("KeyVaultExists", func(t *testing.T) {
		keyVault := azure.GetKeyVaultContext(t, context.Background(), rgName, keyVaultName, subscriptionId)
		assert.Equal(t, keyVaultName, *keyVault.Name, "Virtual Network must exist")
	})

	t.Run("RgExists", func(t *testing.T) {
		assert.True(t, azure.ResourceGroupExistsContext(t, context.Background(), rgName, subscriptionId), "Resource Group must exist")
	})

	t.Run("ValidateTerraformOutputs", func(t *testing.T) {
		assert.NotEmpty(t, keyVaultId, "Key Vault ID must not be empty")
		assert.NotEmpty(t, rgId, "Resource Group ID must not be empty")
	})
}
