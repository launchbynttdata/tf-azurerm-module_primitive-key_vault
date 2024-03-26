package common

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestComposableKeyVault(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("AZURE_SUBSCRIPTION_ID")
	if len(subscriptionId) == 0 {
		t.Fatal("AZURE_SUBSCRIPTION_ID environment variable is not set")
	}

	rgId := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_id")
	rgName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
	keyVaultName := terraform.Output(t, ctx.TerratestTerraformOptions(), "key_vault_name")
	keyVaultId := terraform.Output(t, ctx.TerratestTerraformOptions(), "key_vault_id")

	t.Run("KeyVaultExists", func(t *testing.T) {
		keyVault := azure.GetKeyVault(t, rgName, keyVaultName, subscriptionId)
		assert.Equal(t, keyVaultName, *keyVault.Name, "Virtual Network must exist")
	})

	t.Run("RgExists", func(t *testing.T) {
		assert.True(t, azure.ResourceGroupExists(t, rgName, subscriptionId), "Resource Group must exist")
	})

	t.Run("ValidateTerraformOutputs", func(t *testing.T) {
		assert.NotEmpty(t, keyVaultId, "Key Vault ID must not be empty")
		assert.NotEmpty(t, rgId, "Resource Group ID must not be empty")
	})
}
