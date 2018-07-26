package com.ccc.webapp.controller;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.MediaType;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.ccc.jsonview.DataResponse;
import com.ccc.model.FormData;
import com.ccc.model.TaxObject;
import com.ccc.service.SaleTaxService;
import com.ccc.webapp.exception.advise.UniqueCountyNotFoundException;
import com.ccc.webapp.exception.advise.VehicleTypeNotFoundException;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;


@RestController
public class TaxCalculatorController {
	
	private final Logger logger = LoggerFactory.getLogger( this.getClass());
	
	@Autowired
	SaleTaxService saleTaxService;
	
	@Autowired
	Environment environment;
	
	
	@RequestMapping(value= "/taxCalculator", method=RequestMethod.POST,consumes=MediaType.APPLICATION_JSON_UTF8_VALUE,produces=MediaType.APPLICATION_JSON_UTF8_VALUE )
	public DataResponse getTaxInformation(@RequestBody @Valid FormData json) throws JsonParseException, JsonMappingException, IOException, UniqueCountyNotFoundException{
		StopWatch watch = new StopWatch();
		 watch.start();
		logger.info("request data : "+json.toString());
		validateVehicleType(json);
		Double vehicleValue = json.getVehicleValue(); 
		Double vehicleMSRPValue = json.getVehicleMSRPValue(); 
		Integer modelYear = json.getVehicleYear(); 
		String lossDate = json.getLossDate();
		
		DecimalFormat df = new DecimalFormat("#.00");
		DataResponse res =  new DataResponse();
		//String rName=json.getState();
			logger.debug("calling service API for TransactionId: "+json.getTransactionId());
			List<TaxObject>  list=saleTaxService.getTaxes(json); 
			logger.debug("Succesfully executed service API for TransactionId: "+json.getTransactionId());
			
				List<TaxObject>  percentlist= list.stream().filter(tax -> tax.getUnit().equals("%")).map(tax -> 
				{double taxVal = 0.0;
				 if(tax.getName().equals("RTA")) {
						Integer totaledYear =Integer.valueOf(lossDate.substring(lossDate.lastIndexOf("/")+1));
						int yearOfService = totaledYear-modelYear+1;
						if(yearOfService>13)
							yearOfService=13;
						int depreciatedPercentage = Integer.valueOf(environment.getRequiredProperty("WA.yearofservice."+yearOfService));
						double depreciatedValue = Double.valueOf(vehicleMSRPValue)*depreciatedPercentage/100;			
						taxVal = Math.round(depreciatedValue*Double.valueOf(tax.getValue())/100);
				 }else
					 taxVal= Double.valueOf(vehicleValue)*Double.valueOf(tax.getValue())/100;
					 
				tax.setTaxValue(df.format(taxVal));
				return tax;
				}).collect(Collectors.toList());
				
				List<TaxObject>  dollarlist= list.stream().filter(tax -> tax.getUnit().equals("$")).map(tax -> {
					double taxVal = Double.valueOf(tax.getValue());
					tax.setValue(df.format(taxVal));
					return tax;}).collect(Collectors.toList());
	
				List<TaxObject>  newlist = new ArrayList<TaxObject>();
				newlist.addAll(percentlist);
				newlist.addAll(dollarlist);
				double totalSalesTax = percentlist.parallelStream().map(TaxObject::getTaxValue).mapToDouble(Double:: parseDouble).reduce(0.00,(a,b) -> a+b);
				double totalSalesTaxDollar = dollarlist.parallelStream().filter(tax -> (tax.getUnit().equals("$") && tax.getType().equals("T"))).
						map(TaxObject::getValue).mapToDouble(Double:: parseDouble).reduce(0.00,(a,b) -> a+b);
				
				TaxObject tax = new TaxObject();
				tax.setName("Total Sales tax");
				tax.setValue(String.valueOf(df.format(totalSalesTax+totalSalesTaxDollar)));
				tax.setUnit("$");
				tax.setType("TST");
				newlist.add(tax);
				
				res.setTaxObj(newlist);
				res.setTransactionId(json.getTransactionId());
		watch.stop();
		logger.info("Response data for TransactionId : "+json.toString()+" in time "+watch.toString()+ " with success status");
		return res;
	}
	
	private void validateVehicleType(FormData formData) {
	    if (!formData.getState().equals("GA")) {
	       if(formData.getVehicleType() == null || formData.getVehicleType().isEmpty())
	    	   throw new VehicleTypeNotFoundException(formData.getTransactionId(), formData.getState());
	    }
	}

}
