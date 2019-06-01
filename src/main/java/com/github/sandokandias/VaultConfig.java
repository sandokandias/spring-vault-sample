package com.github.sandokandias;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
public class VaultConfig {

    @Configuration
    @Profile("vault-k8s")
    static class Kubernetes {

    }

    @Configuration
    @Profile("vault-approle")
    static class AppRole {
    }
}

