package com.github.sandokandias;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.vault.core.VaultOperations;
import org.springframework.vault.support.VaultHealth;
import org.springframework.vault.support.VaultResponse;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
public class VaultController {

    private final VaultOperations vaultOperations;

    public VaultController(VaultOperations vaultOperations) {
        this.vaultOperations = vaultOperations;
    }

    @GetMapping(value="/health", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    @ResponseStatus(HttpStatus.OK)
    public VaultHealth health() {
        return vaultOperations.opsForSys().health();
    }

    @PostMapping(value = "/secret/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    @ResponseStatus(HttpStatus.CREATED)
    public VaultResponse create(@PathVariable("id") String id, @RequestBody Map<String, String> request) {
       return  vaultOperations.write("app/secret/"+id, request);
    }

    @GetMapping(value ="/secret/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    @ResponseStatus(HttpStatus.OK)
    public VaultResponse get(@PathVariable("id") String id) {
        return  vaultOperations.read("app/secret/"+id);
    }

}
