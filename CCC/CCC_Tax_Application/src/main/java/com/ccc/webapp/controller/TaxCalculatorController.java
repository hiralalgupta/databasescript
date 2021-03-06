package com.ccc.webapp.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Hyperlink;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFHyperlink;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ccc.jsonview.DataResponse;
import com.ccc.model.County;
import com.ccc.model.FormData;
import com.ccc.model.Region;
import com.ccc.service.RestTemplateService;
import com.ccc.service.VehicleAddressService;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;


@Controller
public class TaxCalculatorController {
	
	@Autowired
	RestTemplateService restTemplateService;
	@Value("${rest.server.url}")
	private String url;
	private static final String EXCEL_TEMPLATE_FILE = "excel-template.xlsx";
	private static final String EXCEL_DONWLOAD_FILE = "tax-calculation.xlsx";
	
	@Autowired
	private VehicleAddressService vehicleAddressService;
	
	@RequestMapping(value= "/addressInfo", method=RequestMethod.GET )
	public @ResponseBody DataResponse getStateAndCountyInformation(){
		List<Region> addressInfo = vehicleAddressService.getRegionInfo();
		DataResponse res =  new DataResponse();
		res.setObj(addressInfo);
		return res;
	}
	
	@RequestMapping(value= "/zipInfo/{county}/{state}", method=RequestMethod.GET )
	public @ResponseBody DataResponse getZipInfo(@PathVariable("county") int county, @PathVariable("state") int state ) throws Exception{
		DataResponse res =  new DataResponse();
		
		if(state == 3 || state == 4){
			List<String> zipData = vehicleAddressService.getCities(county);
			res.setObj(zipData);
		}else{
			org.json.simple.JSONArray zipData = vehicleAddressService.getZipPlus4Info(state, county);
			//List<Integer> zipData = vehicleAddressService.getZipInfo(county);
			res.setObj(zipData.toArray());
		}
		return res;
	}
	@RequestMapping(value= "/uniqueZipInfo", method=RequestMethod.GET )
	public @ResponseBody DataResponse getZipInfo(@RequestParam("regionId") int regionId){
		List<Integer> zipData = vehicleAddressService.getUniqueZipInfo(regionId);
		DataResponse res =  new DataResponse();
		res.setObj(zipData);	
		return res;
	}
	
	@RequestMapping(value= "/plus4Info", method=RequestMethod.GET )
	public @ResponseBody DataResponse getPlus4Info(@RequestParam("county") int county, @RequestParam("zip") int zip){
		List<Integer> zipData = vehicleAddressService.getPlus4Info(county, zip);
		DataResponse res =  new DataResponse();
		res.setObj(zipData);
		return res;
	}
	@RequestMapping(value= "/plus4InfoBsdZip", method=RequestMethod.GET )
	public @ResponseBody DataResponse getPlus4InfoZip(@RequestParam("zip") int zip){
		List<Integer> zipData = vehicleAddressService.getPlus4InfoBasedOnZip(zip);
		DataResponse res =  new DataResponse();
		res.setObj(zipData);
		return res;
	}
	
	@RequestMapping(value= "/getVehicleMake", method=RequestMethod.GET )
	public @ResponseBody DataResponse getVehicleMake(){
		List<Object> vehicleInfo = vehicleAddressService.getVehcileMakeInfo();
		DataResponse res =  new DataResponse();
		res.setObjList(vehicleInfo);
		return res;
	}
	
	@RequestMapping(value= "/vehicleInfo", method=RequestMethod.GET )
	public @ResponseBody DataResponse getVehicleInfo(@RequestParam("vehicleMake") String modelMake ){
		List<Object> addressInfo = vehicleAddressService.getVehcileInfo(modelMake);
		DataResponse res =  new DataResponse();
		res.setObj(addressInfo);
		return res;
	}
	@RequestMapping(value= "/getTaxDetail", method=RequestMethod.POST,consumes=MediaType.ALL_VALUE,produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	public @ResponseBody DataResponse getCalucatedTax(@RequestBody FormData json )throws JsonParseException, JsonMappingException, IOException{
		System.out.println("Getting Tax Details from server...");
		String generatedString = RandomStringUtils.randomAlphabetic(10);
		json.setTransactionId(generatedString);
		DataResponse res=restTemplateService.postDataToWS(url+"/taxCalculator", HttpMethod.POST, json, DataResponse.class);
		return res;
	}
	
	@RequestMapping(value= "/plateInfo/{state}", method=RequestMethod.GET )
	public @ResponseBody DataResponse getPlateInfo(@PathVariable("state") int state){
		List<String> plateInfo = vehicleAddressService.getPlateTypeInfo(state);
		List<String> vehicleType = vehicleAddressService.getVehicleType(state);
		DataResponse res =  new DataResponse();
		res.setObj(plateInfo);
		List<Object> returObjList = new ArrayList<>();
		returObjList.addAll(vehicleType);
		res.setObjList(returObjList);
		
		return res;
	}

	@RequestMapping(value= "/countyInfo", method=RequestMethod.GET)
	public @ResponseBody DataResponse getCountyInfo(@RequestParam("zip") int zip, @RequestParam("plus4") int plus4){
		List<County> plateInfo = vehicleAddressService.getCountyData(zip,plus4);
		HashMap<String,Object> map= new HashMap<>();
		map.put("region", plateInfo.get(0).get_region());
		DataResponse res =  new DataResponse();
		res.setObj(plateInfo);
		res.setMapList(map);
		return res;
	}
	
	@RequestMapping(value= "/regionInfo", method=RequestMethod.GET )
	public @ResponseBody DataResponse getRegionInfo(@RequestParam("countyId") int countyId){
		List<Region> plateInfo = vehicleAddressService.getRegionData(countyId);
		DataResponse res =  new DataResponse();
		res.setObj(plateInfo);
		return res;
	}
	
	@SuppressWarnings("deprecation")
	@RequestMapping(value= "/getExcelReport", method=RequestMethod.POST,consumes=MediaType.ALL_VALUE)
	public void  generateExcelReport(@RequestBody String json, HttpServletResponse response){
		//System.out.println("generateExcelReport() is called...");
		try {
			
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(json);
			JSONObject jsonObject = new JSONObject(obj.toString());

			FileInputStream inputStream = new FileInputStream(new File(EXCEL_TEMPLATE_FILE));
			Workbook workbook = WorkbookFactory.create(inputStream);
 
            Sheet sheet = workbook.getSheetAt(0);
            
            // hyper link style
            CreationHelper createHelper = workbook.getCreationHelper();
            XSSFCellStyle hlinkstyle = (XSSFCellStyle) workbook.createCellStyle();
            XSSFFont hlinkfont = (XSSFFont) workbook.createFont();
            hlinkfont.setUnderline(XSSFFont.U_SINGLE);
            hlinkfont.setColor(HSSFColor.BLUE.index);
            hlinkstyle.setFont(hlinkfont);
            XSSFHyperlink link = (XSSFHyperlink)createHelper.createHyperlink(Hyperlink.LINK_URL);
            
            // render state info
            renderStateInfo(sheet,jsonObject);
            
            // render Other Taxes And Fees 
            renderOtherTaxesAndFeesValues(sheet,jsonObject,link,hlinkstyle);
            
            inputStream.close();
 
            FileOutputStream outputStream = new FileOutputStream(EXCEL_DONWLOAD_FILE);
            workbook.write(outputStream);
            workbook.close();
            outputStream.close();
            System.out.println("Template updated...");
            
            FileInputStream is = new FileInputStream(new File(EXCEL_DONWLOAD_FILE));

            response.setHeader("Content-Disposition", "attachment; filename=\"tax-calculation.xlsx\"");
            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);

            ServletOutputStream os = response.getOutputStream();
            IOUtils.copy(is, os);

            os.close();
            is.close();
            System.out.println("Report downloaded successfully...");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void renderStateInfo(Sheet sheet,JSONObject jsonObject){
		sheet.getRow(1).getCell(0).setCellValue(jsonObject.get("state").toString());
		sheet.getRow(1).getCell(1).setCellValue(jsonObject.get("zip").toString());
		sheet.getRow(1).getCell(2).setCellValue(jsonObject.get("regDate").toString());
		sheet.getRow(1).getCell(3).setCellValue(jsonObject.get("lossDate").toString());
		sheet.getRow(1).getCell(4).setCellValue(jsonObject.get("vehicleValue").toString());
		sheet.getRow(1).getCell(5).setCellValue(jsonObject.get("vin").toString());
		sheet.getRow(1).getCell(6).setCellValue(jsonObject.get("vehicleType").toString());
		sheet.getRow(1).getCell(7).setCellValue(jsonObject.get("make").toString());
		sheet.getRow(1).getCell(8).setCellValue(jsonObject.get("model").toString());
		sheet.getRow(1).getCell(9).setCellValue(jsonObject.get("modelYear").toString());
		sheet.getRow(1).getCell(10).setCellValue(jsonObject.get("vehicleTrim").toString());
		sheet.getRow(1).getCell(11).setCellValue(jsonObject.get("weight").toString());
	}
	
	private void renderOtherTaxesAndFeesValues(Sheet sheet,JSONObject jsonObject,XSSFHyperlink link,XSSFCellStyle hlinkstyle){
		int rowCount=4;
		
		JSONArray rtaFeesArray = jsonObject.getJSONArray("rta");
		for (int i = 0, size = rtaFeesArray.length(); i < size; i++){
			JSONArray jsonArray = rtaFeesArray.getJSONArray(i);
			for (Object object : jsonArray) {
				JSONObject jObject = (JSONObject) object;
			    //System.out.println("rta:\n"+jObject);
			    String checked=getChecked(jObject, "check");
				if(!checked.equalsIgnoreCase("true")) {
					// Set Application fee-Certificate of title's tax value from row-10 and cell-2 and URL value from row-10 and cell 3
					renderOtherTaxesAndFeesValues(sheet,rowCount,jObject.getString("name"),"RTA","$"+jObject.getString("taxValue"),jObject.getString("url"),URLEncoder.encode(jObject.getString("url")),link,hlinkstyle);
					rowCount++;
				}
			}
	    }
		
		if (rowCount > 4) {
			rowCount +=1; // leave one blank row after every fees type
		}
		
		JSONArray titleFeesArray = jsonObject.getJSONArray("titleFees");
		for (int i = 0, size = titleFeesArray.length(); i < size; i++){
			JSONArray jsonArray = titleFeesArray.getJSONArray(i);
			for (Object object : jsonArray) {
				JSONObject jObject = (JSONObject) object;
			    //System.out.println("titleFees:\n"+jObject);
			    String checked=getChecked(jObject, "check");
				if(!checked.equalsIgnoreCase("true")) {
					// Set Application fee-Certificate of title's tax value from row-10 and cell-2 and URL value from row-10 and cell 3
					renderOtherTaxesAndFeesValues(sheet,rowCount,jObject.getString("name"),"Title Fees","$"+jObject.getString("value"),jObject.getString("url"),URLEncoder.encode(jObject.getString("url")),link,hlinkstyle);
					rowCount++;
				}
			}
	    }
		
		rowCount += 1;
		JSONArray registraionFeesArray = jsonObject.getJSONArray("registrationFees");
		for (int i = 0, size = registraionFeesArray.length(); i < size; i++){
			JSONArray jsonArray = registraionFeesArray.getJSONArray(i);
			for (Object object : jsonArray) {
				JSONObject jObject = (JSONObject) object;
				//System.out.println("registraionFees:\n"+jObject);
				String checked=getChecked(jObject, "check");
				if(!checked.equalsIgnoreCase("true")) {
					// Set Application fee-Certificate of title's tax value in row-10 and cell-2 and URL value in row-10 and cell 3
					renderOtherTaxesAndFeesValues(sheet,rowCount,jObject.getString("name"),"Registration Fees","$"+jObject.getString("value"),jObject.getString("url"),URLEncoder.encode(jObject.getString("url")),link,hlinkstyle);
					rowCount++;
				}
			}
	    }
		
		
		rowCount += 1;
		JSONArray titleOptionalFeesArray = jsonObject.getJSONArray("titleOptionalFees");
		for (int i = 0, size = titleOptionalFeesArray.length(); i < size; i++){
			JSONArray jsonArray = titleOptionalFeesArray.getJSONArray(i);
			for (Object object : jsonArray) {
				JSONObject jObject = (JSONObject) object;
				
			    String checked=getChecked(jObject, "check");
				if (!checked.equalsIgnoreCase("false")) {
					renderOtherTaxesAndFeesValues(sheet,rowCount,jObject.getString("name"),"Title Conditional Fees","$"+jObject.getString("value"),jObject.getString("url"),URLEncoder.encode(jObject.getString("url")),link,hlinkstyle);
					rowCount++;
				}
				
			}
	    }
		
		rowCount += 1;
		JSONArray optionalFeesArray = jsonObject.getJSONArray("optionalFees");
		for (int i = 0, size = optionalFeesArray.length(); i < size; i++){
			JSONArray jsonArray = optionalFeesArray.getJSONArray(i);
			for (Object object : jsonArray) {
				JSONObject jObject = (JSONObject) object;
				//System.out.println("optionalFees:\n"+jObject);
				
			    String checked=getChecked(jObject, "check");
			    
				if (checked.equalsIgnoreCase("false")) {
					// Set Application fee-Certificate of title's tax value in rowCount.length and cell-2 and URL value in rowCount.length and cell 3
					renderOtherTaxesAndFeesValues(sheet,rowCount,jObject.getString("name"),"Conditional Fees","$"+jObject.getString("value"),jObject.getString("url"),URLEncoder.encode(jObject.getString("url")),link,hlinkstyle);
					rowCount++;
				}
				
			}
	    }
		
		JSONArray otherOptionalFeesArray = jsonObject.getJSONArray("otherOptionalFees");
		for (int i = 0, size = otherOptionalFeesArray.length(); i < size; i++){
			JSONArray jsonArray = otherOptionalFeesArray.getJSONArray(i);
			for (Object object : jsonArray) {
				JSONObject jObject = (JSONObject) object;
				//System.out.println("optionalFees:\n"+jObject);
				
				// Set Application fee-Certificate of title's tax value in rowCount.length and cell-2 and URL value in rowCount.length and cell 3
				renderOtherTaxesAndFeesValues(sheet,rowCount,jObject.getString("name"),"Conditional Fees","$"+jObject.getString("value"),jObject.getString("url"),URLEncoder.encode(jObject.getString("url")),link,hlinkstyle);
				rowCount++;
			}
	    }
		
		rowCount += 1;
		JSONArray taxesArray = jsonObject.getJSONArray("taxes");
		for (int i = 0, size = taxesArray.length(); i < size; i++){
			JSONArray jArray = taxesArray.getJSONArray(i);
			for (Object object : jArray) {
				JSONObject jObject = (JSONObject) object;
			    //System.out.println("Sales taxes\n"+jObject);
			    
		    	String checked=getChecked(jObject, "check");
				if(!checked.equalsIgnoreCase("true")) {
					// Set Application fee-Certificate of title's tax value in row-10 and cell-2 and URL value in row-10 and cell 3
					renderOtherTaxesAndFeesValues(sheet,rowCount,jObject.getString("name"),"Taxes","$"+jObject.getString("taxValue"),jObject.getString("url"),URLEncoder.encode(jObject.getString("url")),link,hlinkstyle);
					rowCount++;
				}
			}
	    }
		
		JSONArray dollarTaxesArray = jsonObject.getJSONArray("taxesDollar");
		for (int i = 0, size = dollarTaxesArray.length(); i < size; i++){
			JSONArray jArray = dollarTaxesArray.getJSONArray(i);
			for (Object object : jArray) {
				JSONObject jObject = (JSONObject) object;
			    
		    	String checked=getChecked(jObject, "check");
				if(!checked.equalsIgnoreCase("true")) {
					renderOtherTaxesAndFeesValues(sheet,rowCount,jObject.getString("name"),"Taxes","$"+jObject.getString("value"),jObject.getString("url"),URLEncoder.encode(jObject.getString("url")),link,hlinkstyle);
					rowCount++;
				}
			}
	    }
		
		rowCount= rowCount+1 ;
		sheet.getRow(rowCount).getCell(0).setCellValue("Grand Total");
		sheet.getRow(rowCount).getCell(1).setCellValue("$"+jsonObject.get("grandTotal").toString());
		
	}
	
	private void renderOtherTaxesAndFeesValues(Sheet sheet,int rowNum,String feeName,String feeType,String taxValue,String urlStr,String urlValue,XSSFHyperlink link,XSSFCellStyle hlinkstyle){
		//System.out.println("FeeType:"+feeType+",sheet:"+sheet+",rowNum:"+rowNum+",feeName:"+feeName+",taxValue:"+taxValue+",urlStr:"+urlStr+",urlValue:"+urlValue+",link:"+link+",hlinkstyle:"+hlinkstyle);
		sheet.getRow(rowNum).getCell(0).setCellValue(feeName);
		sheet.getRow(rowNum).getCell(1).setCellValue(taxValue);
        Cell useTaxCell=sheet.getRow(rowNum).getCell(2);
        useTaxCell.setCellValue(urlStr);
        link.setAddress(urlValue);
        useTaxCell.setHyperlink((XSSFHyperlink) link);
        useTaxCell.setCellStyle(hlinkstyle);
        sheet.getRow(rowNum).getCell(3).setCellValue(feeType);
	}

	private String getChecked(JSONObject json, String name) {
		String JSON_NULL_STR = "null"; 
	    String value = json.optString(name);
	    // return empty string for "null"
	    if (JSON_NULL_STR.equals(value))
	        return "";
	    return value;
	}
	
	@RequestMapping(value= "/getZIPPLUS4Info", method=RequestMethod.GET )
	public @ResponseBody DataResponse getZIPPLUS4Info(@RequestParam("zipplus4") int zipplus4,@RequestParam("regionId") int regionId){
		Set<String> zipInfo = vehicleAddressService.getZipPlus4(zipplus4,regionId);
		DataResponse res =  new DataResponse();
		res.setObj(zipInfo);
		return res;
	}
}
