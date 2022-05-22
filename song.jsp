<%@page contentType="text/html" import="java.sql.*,java.util.*;" pageEncoding="UTF-8"%>
<%
    try{
      int flag = 0;
      String email = null;
      Cookie c[] = request.getCookies();
      for(int i=0;i<c.length;i++){
        if(c[i].getName().equals("user")){
            email = c[i].getValue();
            break;
        }
      }
      if(email!=null){
           flag = 1;
      }
      else{
           flag = 0;
      }   
      if(request.getParameter("album_code")!=null && request.getParameter("album_name")!=null){
        String album_code = request.getParameter("album_code") ;
        String album_name = request.getParameter("album_name") ;
        try{
           Class.forName("com.mysql.jdbc.Driver");
           Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
           %>
        <style>
            .al_name{
                    position: absolute;
                    transform: translate(-0%, -0%);
                    width: 500px;
                    height: 50px;
                    border-bottom: 5px solid #000;
                    line-height: 50px;
                    overflow: hidden;
            }
            .al_name span{
                    color: #fff;
                    font-size: 30px;
                    background: #000;
                    display: inline-block;
                    padding: 2px 20px;
                    text-transform: uppercase;
            }
        </style>
        <div class="row">
                <div class="col-sm-6">
                    <img src="album/<%=album_code%>.jpg" class="img-fluid">
                </div>	
                <div class="col-sm-4">
                    <div class="al_name"><span><%=album_name%></span></div><br><br>
                    <div class="song" style="margin-top:10px;">
                    <%
                        Statement st = cn.createStatement();
                        ResultSet rs = st.executeQuery("select * from song where album_code = '"+album_code+"'");
                        while(rs.next()){
                    %>		
                            <table class="table table-borderless">
                                <tr>
                                    <td >
                                        <h4 class="card-title" style="font-size:20px;"><%=rs.getString("song_name")%></h4>
                                    </td>
                                    <td style="float:right;font-size:20px;">
                                        <audio controls="controls" >
                                            <source src="album/<%=album_code%>/<%=rs.getString("sn")%>.mp3" type="audio/mp3">
                                        </audio>
                                    </td>
                                </tr>
                            </table>
                        &nbsp;
                        &nbsp;
                    <%
                        }
                    %>
                    </div>
                </div>
                <br><br>
        </div>
        <br><br><br>			
<%
                
                cn.close();
            }
            catch(ClassNotFoundException e){
                System.out.println("Driver : "+ e.getMessage());
            }
            catch(SQLException er){
                System.out.println("SQL : "+er.getMessage());
            }
      }
    }
    catch(NullPointerException er){
        response.sendRedirect("index.jsp");
    }  
%>