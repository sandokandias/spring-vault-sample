package com.github.sandokandias;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.vault.authentication.AppRoleAuthentication;
import org.springframework.vault.authentication.AppRoleAuthenticationOptions;
import org.springframework.vault.authentication.ClientAuthentication;
import org.springframework.vault.client.VaultEndpoint;
import org.springframework.vault.config.AbstractVaultConfiguration;
import org.springframework.vault.support.VaultToken;

import java.net.URI;

@Configuration
public class VaultConfig extends AbstractVaultConfiguration {

    @Value("${vault.uri}")
    private String vaultUri;

    @Value("${vault.token}")
    private String vaultToken;

    @Value("${vault.app-role}")
    private String vaultAppRole;

    @Override
    public VaultEndpoint vaultEndpoint() {
        if (vaultUri != null && !vaultUri.isEmpty())  {
            return VaultEndpoint.from(URI.create(vaultUri));
        }

        throw new IllegalStateException("Vault URI (vault.uri) is null");
    }

    @Override
    public ClientAuthentication clientAuthentication() {
        AppRoleAuthenticationOptions options = AppRoleAuthenticationOptions.builder()
                .appRole(vaultAppRole)
                .initialToken(VaultToken.of(vaultToken))
                .build();
        return new AppRoleAuthentication(options, restOperations());
    }
}
