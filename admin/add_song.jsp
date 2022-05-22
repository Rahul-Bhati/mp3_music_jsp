<%@page contentType="text/html" import="java.sql.*,java.util.*,java.io.File;" pageEncoding="UTF-8"%>
<%
        String email = null;
        Cookie c[] = request.getCookies();
        for(int i=0;i<c.length;i++){
            if(c[i].getName().equals("login")){
                email = c[i].getValue();
                break;
            }
        }
        if(email!=null && session.getAttribute(email)!=null){
            if(request.getParameter("acode")!=null && request.getParameter("ccode")!=null){
                String album_code = request.getParameter("acode");                
                String cat_code = request.getParameter("ccode");
                if(request.getParameter("sname").length()!=0 && request.getParameter("des").length()!=0){
                    String song_name = request.getParameter("sname");
                    String des = request.getParameter("des");
                    int sn = 0;
                    String code = "";
                    LinkedList l = new LinkedList();
                    for(char ch='A' ; ch<='Z' ; ch++){
                        l.add(ch+"");
                    }
                    for(char ch='a' ; ch<='z' ; ch++){
                        l.add(ch+"");
                    }
                    for(char ch='0' ; ch<='9' ; ch++){
                        l.add(ch+"");
                    }
                    Collections.shuffle(l);
                    for(int i=0 ; i<6 ; i++){
                        code = code+l.get(i);
                    }
                    try{
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/mp3_jsp","root","");
                        Statement st = cn.createStatement();
                        ResultSet rs = st.executeQuery("select MAX(sn) from song");
                        if(rs.next()){
                             sn = rs.getInt(1);   
                        }
                        sn = sn + 1 ;
                        code = code+"_"+sn;  
                        Statement st1 = cn.createStatement();
                        ResultSet rs1 = st1.executeQuery("select * from song where song_name='"+song_name+"' AND description='"+des+"'");
                        if(rs1.next()){
                            response.sendRedirect("album.jsp?acode="+album_code+"&ccode="+cat_code+"&song_already=1");
                        }
                        else{
                            PreparedStatement ps = cn.prepareStatement("insert into song values(?,?,?,?,?,?)");
                            ps.setInt(1, sn);
                            ps.setString(2, code);
                            ps.setString(3, song_name);
                            ps.setString(4, des);
                            ps.setString(5, album_code);
                            ps.setString(6, "0");
                            if(ps.executeUpdate()>0){
                                response.sendRedirect("song_upload_page.jsp?scode="+code+"&acode="+album_code+"&ccode="+cat_code);
                            }
                        }
                        cn.close();
                    }
                    catch(Exception ec){
                        out.println(ec.getMessage());
                    } 
                }
            }
        }       
        else{
            response.sendRedirect("index.jsp");
        }
%>

