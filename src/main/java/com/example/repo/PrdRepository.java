package com.example.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.example.model.*;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

@JsonSerialize
@RepositoryRestResource(collectionResourceRel = "product", path = "product")
public interface PrdRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {
	
	public List<Product> findAll();
	public List<Product> findByNameContaining(String name);
}