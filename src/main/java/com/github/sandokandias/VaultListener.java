package com.github.sandokandias;

import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;
import org.springframework.vault.core.VaultOperations;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Component
public class VaultListener implements ApplicationListener<ContextRefreshedEvent> {

    @Override
    public void onApplicationEvent(ContextRefreshedEvent contextRefreshedEvent) {
        VaultOperations vaultOperations = contextRefreshedEvent.getApplicationContext().getBean(VaultOperations.class);
        Map<String, String> body = new HashMap<String, String>() {{
            put("warmUp", LocalDateTime.now().toString());
        }};
        vaultOperations.write("app/warmup/listener", body);
    }
}
