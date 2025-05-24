package org.reservation_backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // Désactiver CSRF car nous utilisons des tokens JWT
            .csrf(csrf -> csrf.disable())
            
            // Configurer la gestion de session
            .sessionManagement(session -> 
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            
            // Configurer les autorisations de requêtes
            .authorizeHttpRequests(auth -> auth
                // Permettre l'accès aux endpoints d'authentification sans authentification
                .requestMatchers("/auth/**").permitAll()
                // Exiger une authentification pour tous les autres endpoints
                .anyRequest().authenticated()
            );

        return http.build();
    }
} 