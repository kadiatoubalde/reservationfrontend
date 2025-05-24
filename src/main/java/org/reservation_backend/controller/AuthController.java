package org.reservation_backend.controller;

import org.reservation_backend.dto.AuthDto;
import org.reservation_backend.dto.UtilisateurDto;
import org.reservation_backend.exception.AccountException;
import org.reservation_backend.service.UserService;
import org.reservation_backend.util.Mapper;
import org.reservation_backend.util.JwtTokenUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.BadCredentialsException;
import org.springframework.web.bind.annotation.*;

import java.util.stream.Collectors;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ResponseEntity<UtilisateurDto> login(@RequestBody @Valid AuthDto authDto){
        try {
            System.out.println("Tentative de connexion pour : " + authDto.getUsername());
            UsernamePasswordAuthenticationToken ua = new UsernamePasswordAuthenticationToken(authDto.getUsername(), authDto.getPassword());
            Authentication authentication = authenticationManager.authenticate(ua);
            Utilisateur user = (Utilisateur) authentication.getPrincipal();
            UtilisateurDto userDto = Mapper.toUtilisateurDto(user);
            String token = jwtTokenUtil.generateToken(user.getUsername(), user.getAuthorities().stream().map(GrantedAuthority::getAuthority).collect(Collectors.toSet()));
            userDto.setToken(token);
            System.out.println("Connexion réussie pour : " + authDto.getUsername());
            return ResponseEntity.ok().header(HttpHeaders.AUTHORIZATION, token)
                    .body(userDto);
        } catch (BadCredentialsException | ClassCastException e) {
            SecurityContextHolder.getContext().setAuthentication(null);
            System.out.println("Erreur de connexion pour : " + authDto.getUsername());
            e.printStackTrace();
            throw new AccountException("Identifiant ou mot de passe incorrect");
        }
    }

    @PostMapping("/register")
    public ResponseEntity<UtilisateurDto> register(@RequestBody @Valid UtilisateurDto userDto){
        System.out.println("Tentative d'inscription pour : " + userDto.getEmail());
        UtilisateurDto registeredUser = userService.register(userDto);
        System.out.println("Inscription réussie pour : " + userDto.getEmail());
        return new ResponseEntity<>(registeredUser, HttpStatus.CREATED);
    }
} 