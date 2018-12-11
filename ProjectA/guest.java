import java.sql.*;
import java.util.*;
import java.io.*;
import java.lang.*;
import java.text.*;
import java.math.*;
import java.util.Calendar;
import java.time.LocalDate;

public class guest {
	public static double dateChoice(LocalDate datei) 
	{
		// double result = 0;
		// Calendar c = Calendar.getInstance();
		// try
		// {
		// 	c.setTime(new SimpleDateFormat("yyyy-MM-dd").parse(datestr));
		// }
		// catch(Exception e)
		// {
		// 	e.printStackTrace();
		// }	
		//LocalDate ld = LocalDate.parse(datestr);
		int dayOfWeek = datei.getDayOfWeek().getValue();
		//System.out.println(dayOfWeek);

		if(dayOfWeek == 5 || dayOfWeek == 6 || dayOfWeek == 7) {
			//System.out.println("1.1");
			return 1.1;
		}
		//System.out.println("1");
		return 1;
	}

	private static double dater(String date1, String date2)
	{
		LocalDate from = LocalDate.parse(date1);
		LocalDate to = LocalDate.parse(date2);
		//System.out.println(from + " to " + to);

		double result = 0;

		for(LocalDate i = from; i.isBefore(to); i = i.plusDays(1))
		{
			result = (result < dateChoice(i)) ? dateChoice(i) : result;
			if((i.getMonthValue() == 1 && i.getDayOfMonth() == 1)		// jan 1
				|| (i.getMonthValue() == 7 && i.getDayOfMonth() == 4)	// july 4
				|| (i.getMonthValue() == 9 && i.getDayOfMonth() == 6)	// sep 6
				|| (i.getMonthValue() == 10 && i.getDayOfMonth() == 30)	// oct 30
				)
				result = (result < 1.25) ? 1.25 : result;
		}
		//System.out.println(result);
		return result;
	}

        // R-3
	private static double pricecheck(Connection conn, String room, String date1, String date2) {
		int bp = BasePrice(conn, room);
		double percent = dater(date1, date2);
		//System.out.println(bp +" * "+ (percent*100) + " = "+ bp*percent);
		System.out.println(bp*percent);
                return bp*percent;
	}

	private static int BasePrice(Connection conn, String room) {
		int result = -1;
		try{
			String query = "select BasePrice from rooms where RoomId='"+room+"'";
			//System.out.println(query);
			PreparedStatement ss = conn.prepareStatement(query);

			ResultSet r = ss.executeQuery();
			while(r.next()) {
				result = r.getInt(1); 
			}
		}
		catch (Exception e) {
		}
		//System.out.println(result);
		return result;
	}

	private static String roomName(Connection conn, String room) {
		String result = "";
		try{
			String query = "select RoomName from rooms where RoomId='"+room+"'";
			//System.out.println(query);
			PreparedStatement ss = conn.prepareStatement(query);

			ResultSet r = ss.executeQuery();
			while(r.next()) {
				result = r.getString(1); 
			}
		}
		catch (Exception e) {
		}
		//System.out.println(result);
		return result;
	}

	private static int maxOccu(Connection conn, String room) {
		int result = -1;
		try{
			String query = "select MaxOcc from rooms where RoomId='"+room+"'";
			//System.out.println(query);
			PreparedStatement ss = conn.prepareStatement(query);

			ResultSet r = ss.executeQuery();
			while(r.next()) {
				result = r.getInt(1); 
			}
		}
		catch (Exception e) {
		}
		//System.out.println(result);
		return result;
	}

	private static String[] roomId(Connection conn) {
		String[] result = new String[10];
		try{
			String query = "select RoomId from rooms";
			//System.out.println(query);
			PreparedStatement ss = conn.prepareStatement(query);

			ResultSet r = ss.executeQuery();
			int i = 0;
			while(r.next()) {
				result[i++] = r.getString(1); 
			}
		}
		catch (Exception e) {
		}
		//System.out.println(result);
		return result;
	}

	// getting list of room with basePrice*percentage by getting two dates as well as 
	// getting option to reserve R-5 
	// you only need to call this fun from main
	// goes with t from guest menu
        // implements R-4
	public static void reservationList(Connection conn)
	{
		Scanner sc = new Scanner(System.in);
		System.out.println("Enter check-in date:");
		String date1 = sc.nextLine();
		System.out.println("Enter check-out date:");
		String date2 = sc.nextLine();

		//System.out.println("Choose a room:");
		//String room = sc.nextLine();
		String[] rooms = new String[10];
		rooms = roomId(conn);
		String[] availrooms = new String[10];
		int j = 0;
		for (int i = 0; i < 10; i++)
		{
			if(checkAvailability1(conn, rooms[i], date1, date2))
			{
				//System.out.println(rooms[i] + "true");
				availrooms[j++] = (rooms[i]);
			}
		}

		System.out.println("index\troomid\troomName\t\t\tNightly rate");
		int index = 1;
		for (String room : availrooms)
		{
			if(room != null)
			{
				System.out.print(index+"\t"+room+"\t"+roomName(conn, room)+ "\t\t");
				pricecheck(conn, room, date1, date2);
				index++;
			}
		}

		//wanna do reservation??
		System.out.println("Pick a room");
		String roomChose = sc.nextLine();
		System.out.println("Room chose : " +roomChose);
		reservationCompleter(conn, roomChose, date1, date2);
	}
        // R-5
	private static void reservationCompleter(Connection conn, String room, String date1, String date2)
	{
		int max = 0, max1 = 0;
		String discount = "";
		Scanner sc = new Scanner(System.in);
		System.out.println("Enter lastname:");
		String lastename = sc.nextLine();
		System.out.println("Enter firstname:");
		String firstname = sc.nextLine();
		System.out.println("Enter discount:");
		discount = sc.nextLine();
		System.out.println("Enter #adults:");
		int adults = sc.nextInt();
		System.out.println("Enter #children:");
		int children = sc.nextInt();

		max = maxOccu(conn, room);
		max1 = adults+children;
		while(max1 > max)
		{
			System.out.println("Max exceeded");
			System.out.println("Enter #adults:");
			adults = sc.nextInt();
			System.out.println("Enter #children:");
			children = sc.nextInt();
			max1 = adults+children;
		}
		double dispercent = 0;
		if(discount.equals("AAA")) dispercent = 0.1;
		else if(discount.equals("AARP")) dispercent = 0.15;

		System.out.println("Room is : " + room + "\n" +
			"NAME: "+ firstname + " "+lastename+ "\n" +
			"Total Occupant: " +(adults+children)+ "\n" +
			"discount: " + dispercent*100);

		Scanner sc1 = new Scanner(System.in);
		System.out.println("Place reservation? y n");
		String yn = sc1.nextLine();
                // TODO I think this is where we call our update function
                if (yn.equals("y")) {
                   // TODO finish adding stuff here
                  System.out.print("DATES: " + date1 + " " + date2);
                  double price = pricecheck(conn, room, date1, date2);
                  updateDB(conn, room, date1, date2, price - (dispercent*100), lastename, firstname, adults, children);
                }
	}

	// returns boolean: true if vacant, false if occupied/partially occupied
        // R-2 
	public static boolean checkAvailability1(Connection conn, String room, String date1, String date2) {
	   Scanner input = new Scanner(System.in);
	   boolean result = true;
	   PreparedStatement stmt = null;
	   ResultSet rset = null;
	   PreparedStatement stmt2 = null;
	   ResultSet rset2 = null;

	   date1 = "\'"+date1+"\'";
	   date2 = "\'"+date2+"\'";

	   try {
	      String query = "SELECT DATEDIFF(" + date2 + "," + date1 + ") as diff";
	      stmt = conn.prepareStatement(query);
	      int x = 0;
	      rset = stmt.executeQuery();
	      while (rset.next()) {
	         x = Integer.parseInt(rset.getString("diff"));
	      }

	      for (int i = 0; i <= x; i++) {
	         // will have rset.next() if TAA is occupied during this day
	         query = 
	         "SELECT RE.*, DATE_ADD(RE.CheckOut, INTERVAL -1 DAY) as justcheckin, (DATE_ADD(" + date1 + ", INTERVAL " + x + " DAY)) as checkDate " +
	         "FROM reservations RE WHERE RE.Room = '" + room + "' AND " +
	         "(SELECT (DATE_ADD(" + date1 + ", INTERVAL " + i + " DAY))) BETWEEN RE.CheckIn AND DATE_ADD(RE.CheckOut, INTERVAL -1 DAY)";
	         stmt = conn.prepareStatement(query);
	         rset = stmt.executeQuery();

	         String days = 
	         "SELECT (DATE_ADD(" + date1 + ", INTERVAL " + i + " DAY)) as checkDate";
	         stmt2 = conn.prepareStatement(days);
	         rset2 = stmt2.executeQuery();

	         while (rset2.next()) {
	            //System.out.print(rset2.getString("checkDate"));

	            if(rset.next()) {
	               //System.out.println(" | occupied");
	               result = false;
	            } else {
	               //System.out.println(" | unoccupied");
	            }
	         }
	      }

	   } catch (Exception e) {
	      System.out.print(e);
	   }
	   return result;
	}


//   // R-1
   public static void RoomsNRates(Connection conn) {
      Scanner input = new Scanner(System.in);
      PreparedStatement stmt = null;
      ResultSet rset = null;

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

            System.out.println(" Name              | Room | ODays | Percentage");
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
         System.out.println();
         InnReservations.clearScreen();
         if ((choice = InnReservations.availabilityOrGoBack()) == 'a') { 
            boolean check = checkAvailability(conn, room);
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
            "SELECT RE.*, DATE_ADD(RE.CheckOut, INTERVAL -1 DAY) as justcheckin, (DATE_ADD('" + date1 + "', INTERVAL '" + x + "' DAY)) as checkDate " +
            "FROM reservations RE WHERE RE.Room = '" + room + "' AND " +
            "(SELECT (DATE_ADD('" + date1 + "', INTERVAL " + i + " DAY))) BETWEEN RE.CheckIn AND DATE_ADD(RE.CheckOut, INTERVAL -1 DAY)";
            stmt = conn.prepareStatement(query);
            rset = stmt.executeQuery();

            String days = 
            "SELECT (DATE_ADD('" + date1 + "', INTERVAL " + i + " DAY)) as checkDate";
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
         System.out.print("Failure: " + e);
      }
            if (result == true) {
               System.out.print("Place a Reservation [y or n]: ");
               String in = input.nextLine();
               if (in.equals("y")) {
                  reservationCompleter(conn, room, date1, date2);
               }
            }
      return result;
   }

   public static void updateDB(Connection conn, String room, String checkin, String checkout, double rate, String lastName, String firstName, int adults, int kids) {
      // TODO 
      // find a way to generate random number
      // insert record into reservations table
      Statement stmt = null;
      ResultSet rset = null;
      int id = 0;
      int code = generateCode(conn);
      try {
	      String query = 
                 "INSERT INTO reservations " + 
                 " VALUES(" + code + ", '" + room + "', '" +
                 checkin + "', '" + checkout + "', " + rate + ", '" +
                 lastName + "', '" + firstName + "', " + adults + ", " +
                 kids + ")";
	      stmt = conn.createStatement();
              stmt.executeUpdate(query);
            
      } catch (Exception e) {
         System.out.print(e);
      }
      System.out.println("Your Reservation is Complete: ");
      System.out.println(" Code: " + id);
      System.out.print("Details: ...");
   }

   public static int generateCode(Connection conn){
      PreparedStatement stmt = null;
      ResultSet rset = null;
      int x = 0;
      
      try {
	      String query = "SELECT MAX(code) as code FROM reservations";
	      stmt = conn.prepareStatement(query);
	      rset = stmt.executeQuery();
	      while (rset.next()) {
	         x = Integer.parseInt(rset.getString("code"));
	      }

      } catch (Exception e) {
         System.out.print(e);
      }
   x++;
   return x;
   }
}
