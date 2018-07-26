package com.ccc.webapp.rest.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.AuthenticationException;

import com.ccc.model.CustomUserDetails;
import com.ccc.model.JwtAuthenticationRequest;
import com.ccc.model.JwtAuthenticationResponse;
import com.ccc.model.User;
import com.ccc.webapp.util.JwtTokenUtil;
/**
 * User: Ankit Mathur
 * Date: 05/08/2017
 */
@Controller
public class JwtAuthenticationRestController {
	   @Value("${jwt.header}")
	    private String tokenHeader;

	    @Autowired
	    private AuthenticationManager authenticationManager;

	    @Autowired
	    private JwtTokenUtil jwtTokenUtil;

	    @Autowired
	    @Qualifier("customUserDetailsService")
	    private UserDetailsService userDetailsService;

	    @RequestMapping(value = "/authentication", method = RequestMethod.POST,consumes=MediaType.ALL_VALUE )
	    public ResponseEntity<?> createAuthenticationToken(@RequestBody JwtAuthenticationRequest authenticationRequest) throws AuthenticationException {
	    	System.out.println("in authentication..");
	        // Perform the security
	        final Authentication authentication = authenticationManager.authenticate(
	                new UsernamePasswordAuthenticationToken(
	                        authenticationRequest.getUsername(),
	                        authenticationRequest.getPassword()
	                )
	        );
	        SecurityContextHolder.getContext().setAuthentication(authentication);

	        // Reload password post-security so we can generate token
	        final CustomUserDetails userDetails =(CustomUserDetails) userDetailsService.loadUserByUsername(authenticationRequest.getUsername());
	        final String token = jwtTokenUtil.generateToken(userDetails);

	        // Return the token
	        return ResponseEntity.ok(new JwtAuthenticationResponse(token));
	    }

	    @RequestMapping(value = "/refresh", method = RequestMethod.GET)
	    public ResponseEntity<?> refreshAndGetAuthenticationToken(HttpServletRequest request) {
	        String token = request.getHeader(tokenHeader);
	        String username = jwtTokenUtil.getUsernameFromToken(token);
	        User user = (User) userDetailsService.loadUserByUsername(username);
	        String refreshedToken=null;
	        /*if (jwtTokenUtil.canTokenBeRefreshed(token, user.getLastPasswordResetDate())) {
	             refreshedToken = jwtTokenUtil.refreshToken(token);
	            return ResponseEntity.ok(new JwtAuthenticationResponse(refreshedToken));
	        } else {
	            return ResponseEntity.badRequest().body(null);
	        }*/
	        return ResponseEntity.ok(new JwtAuthenticationResponse(refreshedToken));
	    }
}
