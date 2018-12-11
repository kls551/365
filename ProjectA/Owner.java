import java.sql.*;
import java.util.*;
import java.io.*;
import java.lang.*;
import java.math.*;

public class Owner {

   // OR-1 call from ownerLoop()
   public static void occupancy(Connection conn) {
      PreparedStatement stmt = null;
      ResultSet rset = null;
      Scanner input = new Scanner(System.in);
      String cont;
      do {
      int dNum = InnReservations.getNumDates();
      if (dNum == 1)
      {
      System.out.println("Enter check-in date (YYYY-MM-DD):");
      String date1 = input.nextLine();
         try {
           String query =  
               " SELECT " +
               "     roooms.room, R.RoomName, IF(count > 1, 'occupied', 'unoccupied') as status " +
               " FROM " +
               " (SELECT " +
               "  hello.room, count(room) as count " +
               " FROM " +
               " (SELECT DISTINCT " +
               "    RE.Room, 'occupied' as occupied " +
               " FROM " +
               "    reservations RE " +
               " WHERE " +
               "    RE.checkIn <= '" + date1 + "' AND RE.CheckOut > '" + date1 + "' " +
               " UNION " +
               " SELECT DISTINCT " +
               "    RE.Room, 'unoccupied' as occupied " +
               " FROM " +
               "    reservations RE " +
               " WHERE " +
               "    (RE.CheckIn <= '" + date1 + "' AND RE.checkout <= '" + date1 + "') OR " +
               "     RE.CheckIn > '" + date1 + "') as hello " +
               " GROUP BY " +
               "     hello.room) as roooms, rooms R " +
               " WHERE " +
               "    R.RoomId = roooms.Room; ";
           System.out.println(query);
            
           
           stmt = conn.prepareStatement(query);
           rset = stmt.executeQuery();
           
           // TODO needs to be spaced better
           while (rset.next()) {
            System.out.print (rset.getString("room"));
            System.out.print (" | " + rset.getString("RoomName"));
            System.out.print (" | " + rset.getString("status"));
            System.out.println();
         }
        } catch (Exception e){
           System.out.println("Create table failure: ");
           System.out.print(e);
           }
      }
      else {
      System.out.println("Enter check-in date (YYYY-MM-DD):");
      String date1 = input.nextLine();
      System.out.println("Enter check-out date (YYYY-MM-DD):");
      String date2 = input.nextLine();
         try {
           String query =  
" SELECT Room,  " +
"          CASE " +
"             WHEN (CheckIn <= '" + date1 + "' AND CheckOut >='" + date2 + "') " +
"                THEN 'FULLY OCCUPIED' " +
"             WHEN (CheckIn <= '" + date1 + "' AND CheckOut BETWEEN '" + date1 + "' AND '" + date2 + "') " +
"                THEN 'PARTIALLY OCCUPIED' " +
"             WHEN (CheckIn BETWEEN '" + date1 + "' AND '" + date2 + "' AND CheckOut > '" + date2 + "') " +
"                THEN 'PARTIALLY OCCUPIED' " +
"             END AS AVAILABILITY  " +
" FROM reservations " +
" WHERE (CheckIn <= '" + date1 + "' AND CheckOut >= '" + date2 + "') " +
"       OR " +
"       (CheckIn <= '" + date1 + "' AND CheckOut BETWEEN '" + date1 + "' AND '1" + date2 + "') " +
"       OR " +
"       (CheckIn BETWEEN '" + date1 + "' AND '" + date2 + "' AND CheckOut > '" + date2 + "') " +
" UNION " +
"    SELECT DISTINCT R.RoomId, 'FULLY VACANT' as status From rooms R WHERE R.RoomId NOT IN (SELECT Room FROM reservations " +
" WHERE (CheckIn <= '" + date1 + "' AND CheckOut >= '" + date2 + "') " +
"       OR " +
"       (CheckIn <= '" + date1 + "' AND CheckOut BETWEEN '" + date1 + "' AND '" + date2 + "') " +
"       OR " +
"       (CheckIn BETWEEN '" + date1 + "' AND '" + date2 + "' AND CheckOut > '" + date2 + "') " +
" ) ";
           System.out.println(query);
            
           
           stmt = conn.prepareStatement(query);
           rset = stmt.executeQuery();
           
           System.out.println();
           InnReservations.clearScreen();
           System.out.println("Status by room");
           while (rset.next()) {
              System.out.print(rset.getString("Room"));
              System.out.println(" | " + rset.getString("AVAILABILITY"));
         }
      char aq = InnReservations.availabilityOrGoBack();
      if (aq == 'a') {
         showResInRange(date1, date2, conn);
      }
        } catch (Exception e){
           System.out.println("Create table failure: ");
           System.out.print(e);
           }
      }
      
      System.out.print("[C]hoose dates or [q]uit: ");
      } while ((cont = input.next()).equals("c"));
   }

// OR-1 branch
// TODO - needs some help in the looping and questions department, but functionality is there
 public static void showResInRange(String date1, String date2, Connection conn) {
       PreparedStatement stmt = null;
       ResultSet rset = null;
       Scanner input = new Scanner(System.in);
       String rorq = InnReservations.getRoomCodeOrQ();
       while(!rorq.equals("q")) {
       System.out.println("Reservations in range");
       String query = 
          "SELECT RE.Code, RE.CheckIn, RE.CheckOut " +
          "FROM reservations RE " +
          "WHERE RE.room = 'HBB' AND RE.CheckIn BETWEEN " + date1 + " AND " + date2 + " " +
          " OR RE.CheckOut BETWEEN " + date1 + " AND " + date2 + "AND RE.Room = '" + rorq + "';";
       try {
       rset = runQuery(query, conn);
       while (rset.next()) {
          System.out.print (rset.getString("RE.Code"));
          System.out.print(" | " + rset.getString("RE.CheckIn"));
          System.out.println(" | " + rset.getString("RE.CheckOut"));
       }
       System.out.print("Enter reservation code for more details "
 	 + "(or (c)ontinue to continue): ");
       String rvCode = input.next();
       if(!rvCode.equals("q")) {
          Owner.resrvDetail(rvCode, conn);
       }
    }
    catch (Exception e) {
       System.out.print("outside catch");
    }rorq = InnReservations.getRoomCodeOrQ();
       }
 
    }


    public static ResultSet runQuery(String query, Connection conn) {
       PreparedStatement stmt = null;
       ResultSet rset = null;
       try {
          stmt = conn.prepareStatement(query);
          rset = stmt.executeQuery();
       } catch (Exception e){
            System.out.println("Create table failure: ");
            System.out.print(e);
       }
       return rset;
    }

   public static void revenue(Connection conn) {
      PreparedStatement stmt = null;
      ResultSet rset = null;
      String[] readArr;
      Scanner input = new Scanner(System.in);
      System.out.print("1 - reservations by month\n");
      System.out.print("2 - revenue per month\n");
      System.out.print("3 - occupied days per month\n");
      System.out.print("Choose one: ");
      String[] res = {"J1", "F1", "M1", "A1", "My1", "Ju1", "Jy1", "Ag1", "Sp1", "Oc1", "Nv1", "Dc1"};
      String[] rev = {"J2", "F2", "M2", "A2", "My2", "Ju2", "Jy2", "Ag2", "Sp2", "Oc2", "Nv2", "Dc2"};
      String[] days = {"J3", "F3", "M3", "A3", "My3", "Ju3", "Jy3", "Ag3", "Sp3", "Oc3", "Nv3", "Dc3"};
      int in = input.nextInt();
      if (in >= 1 && in <= 3) {
         try {
           String query =
"SELECT                                       " +
"   Room  " +
"   , SUM(IF(why.month = 1, count, 0)) as J1 " +
"   , SUM(IF(why.month = 1, rev, 0)) as J2 " +
"   , SUM(IF(why.month = 1, days, 0)) as J3 " +
"   , SUM(IF(why.month = 2, count, 0)) as F1 " +
"   , SUM(IF(why.month = 2, rev, 0)) as F2 " +
"   , SUM(IF(why.month = 2, days, 0)) as F3 " +
"   , SUM(IF(why.month = 3, count, 0)) as M1 " +
"   , SUM(IF(why.month = 3, rev, 0)) as M2 " +
"   , SUM(IF(why.month = 3, rev, 0)) as M3 " +
" " +
"   , SUM(IF(why.month = 4, count, 0)) as A1 " +
"   , SUM(IF(why.month = 4, rev, 0)) as A2 " +
"   , SUM(IF(why.month = 4, days, 0)) as A3 " +
" " +
"   , SUM(IF(why.month = 5, count, 0)) as My1 " +
"   , SUM(IF(why.month = 5, rev, 0)) as My2 " +
"   , SUM(IF(why.month = 5, days, 0)) as My3 " +
" " +
"   , SUM(IF(why.month = 6, count, 0)) as Ju1 " +
"   , SUM(IF(why.month = 6, rev, 0)) as Ju2 " +
"   , SUM(IF(why.month = 6, days, 0)) as Ju3 " +
" " +
"   , SUM(IF(why.month = 7, count, 0)) as Jy1 " +
"   , SUM(IF(why.month = 7, rev, 0)) as Jy2 " +
"   , SUM(IF(why.month = 7, days, 0)) as Jy3 " +
"   , SUM(IF(why.month = 8, count, 0)) as Ag1 " +
"   , SUM(IF(why.month = 8, rev, 0)) as Ag2 " +
"   , SUM(IF(why.month = 8, days, 0)) as Ag3 " +
"   , SUM(IF(why.month = 9, count, 0)) as Sp1 " +
"   , SUM(IF(why.month = 9, rev, 0)) as Sp2 " +
"   , SUM(IF(why.month = 9, days, 0)) as Sp3 " +
"   , SUM(IF(why.month = 10, count, 0)) as Oc1 " +
"   , SUM(IF(why.month = 10, rev, 0)) as Oc2 " +
"   , SUM(IF(why.month = 10, days, 0)) as Oc3 " +
"   , SUM(IF(why.month = 11, count, 0)) as Nv1 " +
"   , SUM(IF(why.month = 11, rev, 0)) as Nv2 " +
"   , SUM(IF(why.month = 11, days, 0)) as Nv3 " +
"   , SUM(IF(why.month = 12, count, 0)) as Dc1 " +
"   , SUM(IF(why.month = 12, rev, 0)) as Dc2 " +
"   , SUM(IF(why.month = 12, days, 0)) as Dc3 " +
"   FROM  " +
"(SELECT RE.Room, MONTH(RE.CheckOut) as month, COUNT(RE.Code) as count, SUM(RE.Rate * DATEDIFF(RE.CheckOut, RE.CheckIn)) as rev, SUM(DATEDIFF(RE.CheckOut, RE.CheckIn)) as days " +
"FROM reservations RE " +
"GROUP BY RE.Room, month(RE.CheckOut)" +
") as why " +
"GROUP BY why.Room;"; 
 

           stmt = conn.prepareStatement(query);
           rset = stmt.executeQuery();

         System.out.println();
         if (in == 1) {readArr = res; System.out.println("Reservations by Month: ");}
         else if (in == 2) {readArr = rev; System.out.println("Revenue Per Month");}
         else {readArr = days; System.out.println("Days Occupied by Month");}
         System.out.println("Rm | Jan  | Feb  | Mar  | Apr  | May  | Jun  | Jul  | Aug  | Sep  | Oct  | Nov  | Dec | total");
           while (rset.next()) {
            System.out.print (rset.getString("Room"));
            int total = 0;
            for (String str : readArr) {
               System.out.print ("| " + Owner.rightPadding(rset.getString(str), 5));
               total += Integer.parseInt(rset.getString(str));
            }
            System.out.println("| " + total);
         }

        } catch (Exception e){
           System.out.println("Table failure: ");
           System.out.print(e);
           }
      }
   }
 
   // can be called by anything
   public static void showRooms(Connection conn) {
      PreparedStatement stmt = null;
      ResultSet rset = null;
      try {
           String query = "SELECT DISTINCT RE.Room, R.RoomName  FROM reservations RE, rooms R WHERE RE.Room = R.RoomId";

           stmt = conn.prepareStatement(query);
           rset = stmt.executeQuery();
           
           while (rset.next()) {
            System.out.print (rset.getString("room"));
            System.out.print (" " + rset.getString("RoomName"));
            System.out.println();
         }

        } catch (Exception e){
           System.out.println("Create table failure: ");
           System.out.print(e);
           }
   }
   
   // OR-4
   // TODO need to list reservation codes
   // also needs a loop
   public static void browseRes(String d1, String d2, Connection conn) {
      PreparedStatement stmt = null;
      ResultSet rset = null;
      Scanner input = new Scanner(System.in);

      String room = InnReservations.getRoomCodeOrQ();
      if (!room.equals("q")) {
           try {
           
           String query = "SELECT * FROM reservations RE WHERE " +
                        "NOT((RE.CheckIn < " + d1 + " AND RE.CheckOut < " + d1 + ") OR (RE.CheckIn > " + d2 + " AND RE.CheckOut > " + d2 + "));";

           stmt = conn.prepareStatement(query);
           rset = stmt.executeQuery();
           
           while (rset.next()) {
            if (room.equals("all") || room.equals(rset.getString("RE.Room")))
            {
               System.out.print (rset.getString("RE.Code"));
               System.out.print (" | " + rset.getString("RE.CheckIn"));
               System.out.print (" | " + rset.getString("RE.CheckOut"));
               System.out.print (" | " + rset.getString("RE.Room"));
               System.out.println();
            }
         }

        } catch (Exception e){
           System.out.println("Query Failure: ");
           System.out.print(e);
           }
      }
      System.out.println("[v]iew details of reservation or [q]uit: ");
      String choice = input.next();
      if (choice.equals("v")) {
         System.out.print("Reservation code: ");
         String reservation = input.next();
         resrvDetail(reservation, conn);
      }
   }



   public static String rightPadding(String str, int num) {
          return String.format("%1$-" + num + "s", str);
            }
   
//   // OR-4 first call
   public static void rooms(String choice, Connection conn) {
      String[] choices = choice.split(" ");
      switch(choices[0]) {
	    case "v":   
               viewRoom(choices[1], conn);
	       break;
	    case "r":   
               listResrv(choices[1], conn);
	       break;
	    case "q":   InnReservations.ownerLoop();
			break;
   }
   }
//   
//   // OR-4 subcall
//   // TODO almost done. Might want to loop it, and give it headers
   public static void viewRoom(String room, Connection conn) {
      PreparedStatement stmt = null;
      ResultSet rset = null;
      try {
           String query =
" SELECT R.RoomName, R.RoomID,  " +
" sum(if(datediff(RE.CheckOut,'2010-12-31') <= 0,datediff(RE.CheckOut,RE.CheckIn), datediff('2010-12-31',RE.CheckIn))) as nights,  " +
" sum(if(datediff(RE.CheckOut,'2010-12-31') <= 0,datediff(RE.CheckOut,RE.CheckIn), datediff('2010-12-31',RE.CheckIn)))/365 as percentage,  " +
" sum(RE.Rate * if(datediff(RE.CheckOut,'2010-12-31') <= 0,datediff(RE.CheckOut,RE.CheckIn), datediff('2010-12-31',RE.CheckIn))) as rev, " +
" sum(RE.Rate * if(datediff(RE.CheckOut,'2010-12-31') <= 0,datediff(RE.CheckOut,RE.CheckIn), datediff('2010-12-31',RE.CheckIn)))/ ( " +
" SELECT sum(RE.Rate * if(datediff(RE.CheckOut,'2010-12-31') <= 0,datediff(RE.CheckOut,RE.CheckIn), datediff('2010-12-31',RE.CheckIn))) FROM reservations RE " +
" WHERE YEAR(RE.CheckIn) = 2010 OR YEAR(RE.CheckOut) = 2010) as percRev " +
" FROM reservations RE, rooms R " +
" WHERE RE.Room = " + room + " AND RE.Room = R.RoomId " +
" GROUP BY R.RoomId";

           stmt = conn.prepareStatement(query);
           rset = stmt.executeQuery();
           
           // TODO give it headers
           while (rset.next()) {
              System.out.println();
               System.out.print (rset.getString("R.RoomName"));
               System.out.print (" " + rset.getString("R.RoomId"));
               System.out.print (" " + rset.getString("nights"));
               System.out.print (" " + rset.getString("percentage"));
               System.out.print (" " + rset.getString("rev"));
               System.out.print (" " + rset.getString("percRev"));
               System.out.println();
               System.out.println();
         }

        } catch (Exception e){
           System.out.println("Query Failure: ");
           System.out.print(e);
           }  
   }
//   
//   //OR-4 subcall
   public static void listResrv(String room, Connection conn) {
      PreparedStatement stmt = null;
      ResultSet rset = null;
      Scanner input = new Scanner(System.in);
      try {
           String query =
" SELECT RE.Code, RE.CheckIn, RE.CheckOut " +
" FROM reservations RE " +
" WHERE RE.Room = " + room +
" ORDER BY RE.CheckIn, RE.CheckOut";

           stmt = conn.prepareStatement(query);
           rset = stmt.executeQuery();
           
           // TODO give it headers
           while (rset.next()) {
              System.out.println();
               System.out.print (rset.getString("RE.Code"));
               System.out.print (" " + rset.getString("RE.CheckIn"));
               System.out.print (" " + rset.getString("RE.CheckOut"));
               System.out.println();
               System.out.println();
         }

        } catch (Exception e){
           System.out.println("Query Failure: ");
           System.out.print(e);
           }  
      System.out.println("[v]iew details of reservation or [q]uit: ");
      String choice = input.next();
      if (choice.equals("v")) {
         System.out.print("Reservation code: ");
         String reservation = input.next();
         resrvDetail(reservation, conn);
      }
   }
   
   // called by OR-1,3,4
   public static void resrvDetail(String reservation, Connection conn) {
      PreparedStatement stmt = null;
      ResultSet rset = null;
      Scanner input = new Scanner(System.in);
      try {
           String query =
            "SELECT R.RoomName, RE.* FROM reservations RE INNER JOIN rooms R ON RE.Room = R.RoomId WHERE RE.Code = '" + reservation + "'";

           stmt = conn.prepareStatement(query);
           rset = stmt.executeQuery();
           
           // TODO give it headers
           System.out.println(Owner.rightPadding("Room Name", 20) + Owner.rightPadding(" | Code", 6) + Owner.rightPadding(" | Room", 4));
           while (rset.next()) {
               System.out.print (Owner.rightPadding(rset.getString("R.RoomName"), 20));
               System.out.print (" | " + Owner.rightPadding(rset.getString("RE.Code"), 6));
               System.out.print (" | " + rset.getString("RE.Room"));
               System.out.print (" | " + rset.getString("RE.CheckIn"));
               System.out.print (" | " + rset.getString("RE.CheckOut"));
               System.out.print (" | " + rset.getString("RE.Rate"));
               System.out.print (" | " + rset.getString("RE.LastName"));
               System.out.print (" | " + rset.getString("RE.FirstName"));
               System.out.print (" | " + rset.getString("RE.Adults"));
               System.out.print (" | " + rset.getString("RE.Kids"));
               System.out.println();
               System.out.println();
         }

        } catch (Exception e){
           System.out.println("Query Failure: ");
           System.out.print(e);
         }  
   }

//   // R-1
   public static void RoomsNRates(Connection conn) {
      Scanner input = new Scanner(System.in);
      PreparedStatement stmt = null;
      ResultSet rset = null;

      System.out.println("Display Rooms");

      String room;
      while (!(room = InnReservations.getRoomCodeOrQ()).equals("q")){ 
         try {
            String query =
               " SELECT R.RoomName, R.RoomID,  " +
               " sum(if(datediff(RE.CheckOut,'2010-12-31') <= 0,datediff(RE.CheckOut,RE.CheckIn), datediff('2010-12-31',RE.CheckIn))) as nights,  " +
               " sum(if(datediff(RE.CheckOut,'2010-12-31') <= 0,datediff(RE.CheckOut,RE.CheckIn), datediff('2010-12-31',RE.CheckIn)))/365 as percentage " +
               " FROM reservations RE, rooms R " +
               " WHERE RE.Room = '" + room + "' AND RE.Room = R.RoomId " +
               " GROUP BY R.RoomId";

            stmt = conn.prepareStatement(query);
            rset = stmt.executeQuery();

            // TODO needs headers
            while (rset.next()) {
               System.out.print(rset.getString("R.RoomName"));
               System.out.print(" | " + rset.getString("R.RoomId"));
               System.out.print(" | " + rset.getString("nights"));
               System.out.println(" | " + rset.getString("percentage"));
            }
         } catch (Exception e) {
            System.out.println(e);
         }
         //if((char choice = InnReservations.availabilityOrGoBack().equals("a")) {
         //if ((char choice = InnReservations.availabilityOrGoBack()) == 'a') {
         char choice;
         if ((choice = InnReservations.availabilityOrGoBack()) == 'a') { 
            checkAvailability(conn, room);
         }
      }
   }

   // returns boolean: true if vacant, false if occupied/partially occupied
   public static boolean checkAvailability(Connection conn, String room) {
      Scanner input = new Scanner(System.in);
      boolean result = true;
      PreparedStatement stmt = null;
      ResultSet rset = null;
      PreparedStatement stmt2 = null;
      ResultSet rset2 = null;

      System.out.println("Enter check-in date (YYYY-MM-DD):");
      String date1 = input.nextLine();
      System.out.println("Enter check-out date (YYYY-MM-DD):");
      String date2 = input.nextLine();

      try {
         String query = "SELECT DATEDIFF('" + date2 + "', '" + date1 + "') as diff";
         stmt = conn.prepareStatement(query);
         int x = 0;
         rset = stmt.executeQuery();
         while (rset.next()) {
            x = Integer.parseInt(rset.getString("diff"));
         }

         for (int i = 0; i <= x; i++) {
            // will have rset.next() if TAA is occupied during this day
            query = 
            "SELECT RE.*, DATE_ADD(RE.CheckOut, INTERVAL -1 DAY) as justcheckin, (DATE_ADD('" + date1 + "', INTERVAL " + x + " DAY)) as checkDate " +
            "FROM reservations RE WHERE RE.Room = '" + room + "' AND " +
            "(SELECT (DATE_ADD('" + date1 + "', INTERVAL " + i + " DAY))) BETWEEN RE.CheckIn AND DATE_ADD(RE.CheckOut, INTERVAL -1 DAY)";
            stmt = conn.prepareStatement(query);
            rset = stmt.executeQuery();

            String days = 
            "SELECT (DATE_ADD(" + date1 + ", INTERVAL " + i + " DAY)) as checkDate";
            stmt2 = conn.prepareStatement(days);
            rset2 = stmt2.executeQuery();

            while (rset2.next()) {
               System.out.print(rset2.getString("checkDate"));

               if(rset.next()) {
                  System.out.println(" | occupied");
                  result = false;
               } else {
                  System.out.println(" | unoccupied");
               }
            }
         }

      } catch (Exception e) {
         System.out.print(e);
      }
      return result;
   }

   public static void updateDB(String[] insertion) {

   }

}
