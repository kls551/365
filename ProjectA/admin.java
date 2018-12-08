import java.sql.*;
import java.util.*;
import java.io.*;
import java.lang.*;
import java.text.*;
import java.math.*;

public class admin {
	public static int rows(Connection conn, String table) {
		int result = -1;
		try{
			String query = "select count(*) from "+table;
			PreparedStatement ss = conn.prepareStatement(query);

			ResultSet r = ss.executeQuery();
			while(r.next()) {
				result = r.getInt(1); 
			}
		}
		catch (Exception e) {
		}
		return result;
	}

	public static void insertInto(Connection conn, String table) {
		try{
			Statement ss = conn.createStatement();
			ss.executeUpdate("insert into "+table+" select * from INN."+table);
			System.out.println("INSERTED: " +table);
		}
		catch (Exception e) {
		}
	}

	public static String currentStatusDis(Connection conn) {
		int result = 0;
		int result1 = 0;
		String s = "", sresult ="";


		result = rows(conn, "rooms");
		result1 =rows(conn, "reservations");

		if(result == 0 || result1 == 0)
		{
			s = "empty";
		}
		else if(result >= 10 && result1 >= 100)
		{
			s = "full";
		}
		else
		{
			s = "no database";
		}
		sresult = "Current Status: " + s + "\n" + "Reservations: " + result1 + "\n"
                + "Rooms: " + result + "\n\n";

		return sresult;
	}

	public static void tableDisplay(Connection conn, Scanner sc) {
		System.out.println("Enter table to view 0 for rooms 1 for reservations");
		switch(sc.nextInt()) {
		    case 0:
		        tableDisplayRoom(conn);
		        break;
		    case 1:
		        tableDisplayRes(conn);
		        break;
		    default:
		}
	}

	public static void tableDisplayRoom(Connection conn) {
		try {
			String query = "select * from rooms";
			PreparedStatement ss = conn.prepareStatement(query);

			ResultSet r = ss.executeQuery();
			int i = 1;
			//System.out.println("RoomID\tRoomName\t\t\tBeds\tBedType\tMaxOcc\tBasePrice\tDecor");
			while(r.next())
			{
				System.out.print (r.getString(1));
				System.out.print (", " + r.getString(2));
				System.out.print (", " + r.getInt(3));
				System.out.print(", " + r.getString(4));
				System.out.print(", " + r.getInt(5));
				System.out.print(", " + r.getInt(6));
				System.out.println(", " + r.getString(7));
				i++;
			}
			r.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static void tableDisplayRes(Connection conn) {
		try {
			String query = "select * from reservations";
			PreparedStatement ss = conn.prepareStatement(query);

			ResultSet r = ss.executeQuery();
			int i = 1;
			//System.out.println("RoomID\tRoomName\t\t\tBeds\tBedType\tMaxOcc\tBasePrice\tDecor");
			while(r.next())
			{
				System.out.print (r.getInt(1));
				System.out.print (", " + r.getString(2));
				System.out.print (", " + r.getDate(3));
				System.out.print(", " + r.getDate(4));
				System.out.print(", " + r.getInt(5));
				System.out.print(", " + r.getString(6));
				System.out.print(", " + r.getString(7));
				System.out.print(", " + r.getInt(8));
				System.out.println(", " + r.getInt(9));
				i++;
			}
			r.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void clearDB(Connection conn) {

	    try {	
	    	Statement ss = conn.createStatement();

	    	ss.executeUpdate("delete from rooms");
	    	ss.executeUpdate("delete from reservations");
	        
	    }
	    catch (Exception e) {
	        System.out.println("ee96: " + e);
	    }
	}

	public static void deleteDB(Connection conn) {

	    try {	
	    	Statement ss = conn.createStatement();

	    	ss.executeUpdate("drop table rooms, reservations");
	    	System.out.println("tables dropped!");
	    }
	    catch (Exception e) {
	        System.out.println("ee96: " + e);
	    }
	}

}