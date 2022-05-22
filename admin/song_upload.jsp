<%@ page import="java.io.*" %>
<%
    try{
        String email = null;
        Cookie c[] = request.getCookies();
        for(int i=0;i<c.length;i++){
            if(c[i].getName().equals("login")){
                email = c[i].getValue();
                break;
            }
        }
        if(email==null && session.getAttribute(email)==null){
            response.sendRedirect("index.jsp");
        }
        else{
            if(request.getParameter("scode")!=null && request.getParameter("ccode")!=null && request.getParameter("acode")!=null){
                String album_code = request.getParameter("acode");
                String cat_code = request.getParameter("ccode");
                String song_code = request.getParameter("scode");
                String contentType = request.getContentType();
                int sn = 0;
                try{
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/youtube","root","");
                    Statement st = cn.createStatement();
                    ResultSet rs = st.executeQuery("select * from album_category");
                    if(rs.next()){
                        sn = rs.getString("sn");
                    }
                    cn.close();
                }
                catch(ClassNotFoundException e){
                    System.out.println("Driver : "+ e.getMessage());
                }
                catch(SQLException er){
                    System.out.println("SQL : "+er.getMessage());
                }
                String imageSave=null;
                byte dataBytes[]=null;
                String saveFile=null;
                if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0))
                {
                DataInputStream in = new DataInputStream(request.getInputStream());
                int formDataLength = request.getContentLength();
                dataBytes = new byte[formDataLength];
                int byteRead = 0;
                int totalBytesRead = 0;
                while (totalBytesRead < formDataLength)
                {
                byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
                totalBytesRead += byteRead;
                }
               
                /*String code="";
                try{
                    ....
                    ...
                    ....
                ResultSet rs=st.executeQuery("select code from table_name where email='"+email+"'");
                if(rs.next()){
                    code=rs.getString(1);
                }

                } 
                catch(Exception er){

                }*/
                String file = new String(dataBytes);
                /*saveFile = file.substring(file.indexOf("filename=\"") + 10);
                saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
                saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1, saveFile.indexOf("\""));*/
                
                 saveFile = sn+".mp3";
                 //out.println(saveFile);
                // out.print(dataBytes);
                int lastIndex = contentType.lastIndexOf("=");
                String boundary = contentType.substring(lastIndex + 1, contentType.length());
                // out.println(boundary);
                int pos;
                pos = file.indexOf("filename=\"");
                pos = file.indexOf("\n", pos) + 1;
                pos = file.indexOf("\n", pos) + 1;
                pos = file.indexOf("\n", pos) + 1;
                int boundaryLocation = file.indexOf(boundary, pos) - 4;
                int startPos = ((file.substring(0, pos)).getBytes()).length;
                int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;
                try
                {
                    FileOutputStream fileOut = new FileOutputStream(request.getRealPath("/")+"album/"+album_code+"/"+saveFile);


                    // fileOut.write(dataBytes);
                    fileOut.write(dataBytes, startPos, (endPos - startPos));
                    fileOut.flush();
                    fileOut.close();
                    response.sendRedirect("song.jsp?acode="+album_code+"&ccode="+cat_code+"&song_success=1");
                }
                catch (Exception e){
                    response.sendRedirect("song.jsp?acode="+album_code+"&ccode="+cat_code+"&img_error=1");
                }
                }
                //response.sendRedirect("index.jsp");
            }
          }
    }
        catch(NullPointerException er){
            response.sendRedirect("index.jsp");
        } 
%>
