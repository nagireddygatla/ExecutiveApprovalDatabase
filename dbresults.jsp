<%@page import="java.awt.geom.CubicCurve2D"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, javax.naming.*"%>
<%
	Connection con = null;
	String check = null;
	String from = null;
	String to = null;
	String mulcalc = null;
	String multi = null;
	File file = null;
	FileWriter fw = null;
	BufferedWriter writer = null;
	String filename = null;
	String [] mulcalcsplit = null;
	String [] mulcalcarray=null;
	mulcalcarray = new String[5];
	String d3var = null;
	//System.out.println(new File(".").getAbsolutePath());
%>

<table border="1">
	<thead>
		<tr>
			<%
				try {
					
					Class.forName("com.mysql.jdbc.Driver").newInstance();
					con = DriverManager.getConnection(
							"jdbc:mysql://localhost:3306/execapp", "root", "root");
					check = request.getParameter("check");
					from = request.getParameter("from");
					to = request.getParameter("to");
					//System.out.println("Hello:" + from);
					//System.out.println("Hello:" + to);
					mulcalc = request.getParameter("mulcalc");
					multi = request.getParameter("multi");
				/*	
					if (check.equalsIgnoreCase("calchart")) {
						if (mulcalc.contains(",")) {
							//filename = "multiplecalc.csv";
							mulcalcsplit = mulcalc.split(",");
							
						}
					

					}*/
					System.out.println("Value coming for calculation"+mulcalc);
					System.out.println("Value coming for data"+multi);
							
					
					if (check.equalsIgnoreCase("calchart")) {
						if (mulcalc.contains(",")) {
							mulcalcsplit = mulcalc.split(",");
							d3var = multi.substring(1, multi.length()-1);
						}
						else {
							
							
							d3var = mulcalc;
						}

					}

					if (check.equalsIgnoreCase("datachart")) {
						if (multi.contains(",")) {
							
							d3var = mulcalc;
						
						}

						else {
							
							d3var = mulcalc;
						}

					}
					
					System.out.println("FInal value:"+d3var);

					filename = "alldata.csv";
					System.out.println(filename);
				//	file = new File(filename);

				file = new File("C:\\Users\\Nagi Reddy\\Desktop\\Machine_Learning_AndrewNg\\"
									+ filename);
				
				Boolean del = file.delete();
				System.out.println("File deleted or not - true means file deleted:"+del);
				System.out.println("file exists or not - false means file doesnt exists and is deleted:"+file.exists());

					if (!file.exists())
						file.createNewFile();
					fw = new FileWriter(file);
					writer = new BufferedWriter(fw);
			
				}

				catch (Exception e)
				{
					System.out.print(e);
					e.printStackTrace();
				}
				ResultSet rsdata = null;
				ResultSet aResultset1 = null;
				try
				{
					//System.out.println("hello");
					Statement a = con.createStatement();
					//System.out.println(a);
					//Statement st = con.createStatement();
					//Statement st1 = con.createStatement();
					int actColmns = 6;
					String dispQuery = "select datasource,recdate," + mulcalc
							+ " from ead where recdate between '" + from
							+ "' and '" + to + "' and datasource IN (" + multi
							+ ")";
					//System.out.println(dispQuery);
					writer.write("datasource,date,value");
					aResultset1 = a.executeQuery(dispQuery);
					ResultSetMetaData rsmd = aResultset1.getMetaData();
					int columnsNumber = rsmd.getColumnCount();
					String name = rsmd.getColumnName(1);
					if (actColmns != 0 || dispQuery != null) {
						for (int i = 1; i <= columnsNumber; i++)
						{
							String tabHeader = rsmd.getColumnName(i);
							
			%>
			<th><%=tabHeader%></th>
			<%
				}
					}

					writer.newLine();
			%>
		</tr>
	</thead>
	<tbody>

		<%
			//System.out.println("select datasource,recdate," + mulcalc
			//			+ " from ead where recdate between '" + from
				//		+ "' and '" + to + "' and datasource IN (" + multi
					//	+ ")");
				
			rsdata = a.executeQuery("select datasource,recdate," + mulcalc
						+ " from ead where recdate between '" + from
						+ "' and '" + to + "' and datasource IN (" + multi
						+ ")");
			
			
			
				while (rsdata.next()) {
		%><tr>
			<%
				for (int i = 1; i <= columnsNumber; i++)
						{
							String values = rsdata.getString(i);
							//System.out.println(rsdata.getString(i));
							if(i==2){
								
								String [] dateparts = values.split("-");
								mulcalcarray[i-1] =dateparts[2] + "/" + dateparts[1] + "/" + dateparts[0];
								
							}else{
							mulcalcarray[i-1] = values;
							}
							if (i != columnsNumber) {
								if (i==2) {
									
									//System.out.println(values);
									String[] parts = values.split("-");
									values = parts[2] + "/" + parts[1] + "/"
											+ parts[0];
								}
								if(!(check.equalsIgnoreCase("calchart") && mulcalc.contains(","))){
								writer.write(values + ",");
								}
							}

							else {
								if (i==2) {
									String[] parts = values.split("-");
									values = parts[2] + "/" + parts[1] + "/"
											+ parts[0];
								}
								if(!(check.equalsIgnoreCase("calchart") && mulcalc.contains(","))){
								writer.write(values);
								}
							}
							
			%>

			<td><%=values%></td>
			<%
		
			
			
				}
			
			if((check.equalsIgnoreCase("calchart") && mulcalc.contains(","))){
				for(int k = 0;  k<mulcalcsplit.length; k++){
					
					writer.write(mulcalcsplit[k]+","+mulcalcarray[1]+","+mulcalcarray[k+2]);
					writer.newLine();		
				}
			
				}
			if(!(check.equalsIgnoreCase("calchart") && mulcalc.contains(","))){
						writer.newLine();
			}
			%>
		</tr>
		<%
			}
			}

			catch (SQLException e) {
				e.printStackTrace();
			}
			aResultset1.close();
			rsdata.close();
			con.close();
			writer.flush();
			writer.close();
			fw.close();
		%>
	</tbody>
</table>
<input type="hidden" id="d3var" value='<%=d3var%>'>