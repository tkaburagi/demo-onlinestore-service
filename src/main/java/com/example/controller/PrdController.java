
package com.example.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.example.model.Product;
import com.example.repo.PrdRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.netflix.appinfo.InstanceInfo;
import com.netflix.discovery.EurekaClient;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;

@JsonSerialize
@RestController
public class PrdController {
	
	@Autowired
	RestTemplate template;
	
	@Autowired
	EurekaClient client;
	
	@Autowired
	private PrdRepository repo;
	
	@HystrixCommand
	@RequestMapping("/")
	public List<Product> getAllPrds() {
		return repo.findAll();
	}
	
	@HystrixCommand
	@RequestMapping("/search")
	public List<Product> getPrdsByName(@RequestParam("name") String name) {
		return repo.findByNameContaining(name);
	}
	
	@HystrixCommand
	@RequestMapping("/kill")
	public String kill() {
		System.exit(-1);
		return "killed!";
	}

	@HystrixCommand
	@RequestMapping("/v")
	public String showVersion() {
		return System.getenv("VERSION");
	}
	
	@RequestMapping("/getinstance")
	public String getInstance() throws JsonProcessingException, IOException {
		String version = System.getenv("VERSION");
		
		String vcap = System.getenv("VCAP_APPLICATION");
		ObjectMapper mapper = new ObjectMapper();
		JsonNode vcap_app = mapper.readTree(vcap);

		InstanceInfo info = client.getNextServerFromEureka("ONLINESTORE-USER", false);
		String targetUrl = UriComponentsBuilder.fromUriString(info.getHomePageUrl()).path("/getinstance").build().toString();
		String resultFromUser = template.getForObject(targetUrl, String.class);
		
		return  "Service App = " + vcap_app.get("instance_index").asText()  + " (version = " + version+ ")" + "," + resultFromUser;
	}
	
	@RequestMapping("/getlocalinfo")
	public String[] getLocalInfo() throws JsonProcessingException, IOException {
		String vcap = System.getenv("VCAP_APPLICATION");
		ObjectMapper mapper = new ObjectMapper();
		JsonNode vcap_app = mapper.readTree(vcap);
		String[] list = new String[3];
		list[0] = System.getenv("CF_INSTANCE_ADDR");
		list[1] = System.getenv("VERSION");
		list[2] = vcap_app.get("instance_index").asText();
		return list;
	}
}
