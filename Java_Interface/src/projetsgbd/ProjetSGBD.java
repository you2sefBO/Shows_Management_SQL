/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMain.java to edit this template
 */
package projetsgbd;


import javafx.application.Application;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import java.sql.*;

public class ProjetSGBD extends Application {

    private TextField queryField;
    private Button executeButton;
    private TableView<TableRow> resultTable;
    private ObservableList<TableRow> data;

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) {
        queryField = new TextField();
        queryField.setPromptText("Entrez votre requête SQL ici...");

        executeButton = new Button("Exécuter");
        executeButton.setOnAction(e -> executeQuery());

        resultTable = new TableView<>();
        resultTable.setEditable(false);

        TableColumn<TableRow, String> col1 = new TableColumn<>("Colonne 1");
        col1.setCellValueFactory(cellData -> cellData.getValue().column1);

        TableColumn<TableRow, String> col2 = new TableColumn<>("Colonne 2");
        col2.setCellValueFactory(cellData -> cellData.getValue().column2);
        
        TableColumn<TableRow, String> col3 = new TableColumn<>("Colonne 3");
        col3.setCellValueFactory(cellData -> cellData.getValue().column3);

        TableColumn<TableRow, String> col4 = new TableColumn<>("Colonne 4");
        col4.setCellValueFactory(cellData -> cellData.getValue().column4);
        resultTable.getColumns().addAll(col1, col2, col3, col4);

        data = FXCollections.observableArrayList();
        resultTable.setItems(data);

        VBox vbox = new VBox(10, queryField, executeButton, resultTable);
        Scene scene = new Scene(vbox, 800, 600);

        primaryStage.setTitle("Connexion Base de Données avec JavaFX");
        primaryStage.setScene(scene);
        primaryStage.show();
    }

    private void executeQuery() {
        String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
        String username = "system";  
        String password = "youssef02"; 
        Connection conn = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            conn = DriverManager.getConnection(url, username, password);

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(queryField.getText());

            data.clear();

            while (rs.next()) {
                String column1 = rs.getString(1);  
                String column2 = rs.getString(2);  
                String column3 = rs.getString(3);
                String column4 = rs.getString(4);
                data.add(new TableRow(column1, column2,column3, column4));
            }


            rs.close();
            stmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
            showErrorDialog("Erreur de connexion à la base de données !");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            showErrorDialog("Le driver Oracle n'est pas trouvé !");
        } finally {
          
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

 
    private void showErrorDialog(String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle("Erreur");
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }

    public static class TableRow {
        private final StringProperty column1;
        private final StringProperty column2;
        private final StringProperty column3;
        private final StringProperty column4;
        public TableRow(String column1, String column2,String column3, String column4) {
            this.column1 = new SimpleStringProperty(column1);
            this.column2 = new SimpleStringProperty(column2);
            this.column3 = new SimpleStringProperty(column3);
            this.column4 = new SimpleStringProperty(column4);
        }

        public StringProperty getColumn1() {
            return column1;
        }

        public StringProperty getColumn2() {
            return column2;
        }
        public StringProperty getColumn3() {
            return column3;
        }
        public StringProperty getColumn4() {
            return column4;
        }
    }
}
