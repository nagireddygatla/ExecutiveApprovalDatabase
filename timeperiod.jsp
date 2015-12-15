<%@page import="java.awt.geom.CubicCurve2D"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, javax.naming.*"%>
<%
Connection con = null;
String check = null;
String muldata = null;
String mulcalc = null;
String maxdate = null;
String mindate = null;
String date1 = null;
String month1 = null;
String date2 = null;
String month2 = null;

	try{
	 check= request.getParameter("check");
	 muldata = request.getParameter("muldata");
	 mulcalc = request.getParameter("mulcalc");
	 
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	con= DriverManager.getConnection("jdbc:mysql://localhost:3306/execapp", "root","root");
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}

	ResultSet rs1 = null;

	try
	{

		Statement st1=con.createStatement();
		String query = "Select min(recdate),max(recdate) from EAD where datasource IN ("+muldata+")";
		System.out.println(query);
		rs1 = st1.executeQuery(query);
	
		while(rs1.next()){
				mindate = rs1.getString(1);
				maxdate = rs1.getString(2);
			
				}
		String[] parts1 = maxdate.split("-");
		date1 = parts1[0]; // 004
		month1 = parts1[1];	
		String[] parts2 = mindate.split("-");
		date2 = parts2[0]; // 004
		month2 = parts2[1];
		System.out.println(date1);
		System.out.println(month1);
	
	%>


	<input type="hidden" id="date1" value='<%=date1%>'>
	<input type="hidden" id="month1" value='<%=month1%>'>
	<input type="hidden" id="date2" value='<%=date2%>'>
	<input type="hidden" id="month2" value='<%=month2%>'>
<%
	}
	catch (SQLException e) {
    e.printStackTrace();
	}
%>
<%
	   	 rs1.close();
		 con.close();
		%>