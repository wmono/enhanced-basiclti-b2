package ca.ubc.ctlt.encryption;

import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

import static org.apache.commons.csv.CSVFormat.EXCEL;

/**
 * Created by compass on 2014-09-08.
 */
public class Bulk {

    private final String directory = "/Users/compass/Downloads/";
    private final String inputFile = directory + "chem121.csv";
    private final String outputName = directory+ "chem121_sapling.csv";

    public Iterable<CSVRecord> load() {
        Reader in = null;
        try {
//            in = new FileReader("/Users/compass/Downloads/test.csv");
            in = new FileReader(inputFile);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        Iterable<CSVRecord> records = null;
        try {
            records = EXCEL.parse(in);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return records;

    }

    public void encrypt(Iterable<CSVRecord> records) {
//        Encryption encryptor = new Encryption("random_sapling_secrete");
        Encryption encryptor = new Encryption("sapling_4FfgWzLUyb");

        List data = new ArrayList();

        for (CSVRecord record : records) {
            String[] row = new String[5];
            // first name
            row[0] = encryptor.encrypt(record.get(0));
            // last name
            row[1] = encryptor.encrypt(record.get(1));
//            System.out.println(record.get(2));
            String[] email = record.get(2).split("@");
//            row[2] = row[3] = Encryption.hashEmail(email[0]) + "@" + email[1];
            row[2] = row[3] = encryptor.encrypt(email[0]) + "@" + email[1];
            row[4] = "2bechanged!";
            data.add(row);
        }

        try {
            FileOutputStream out = new FileOutputStream(outputName);
            OutputStreamWriter writer = new OutputStreamWriter(out);
            CSVPrinter printer = new CSVPrinter(writer, EXCEL);
//            CSVPrinter printer = new CSVPrinter(System.out, EXCEL);
            printer.printRecord(new String[]{"First Name", "Last Name", "Email", "Username", "Password"});
            printer.printRecords(data);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    public static void main(String[] args) {
        Bulk b = new Bulk();
        Iterable<CSVRecord> r = b.load();
        b.encrypt(r);
    }
}
