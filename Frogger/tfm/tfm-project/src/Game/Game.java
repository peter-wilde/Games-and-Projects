package Game;



import java.util.ArrayList;

import javax.swing.JFrame;
import javax.swing.Timer;

public class Game {

	
    public static void main(String[] args) {
        System.out.println("Teh fightnig mognooses");
        
        GameModel model = new GameModel();
        GameView view = new GameView(model);
        GameController controller = new GameController(model, view);		
		
		view.registerListener(controller);
		FroggorMouseController mouseController = new FroggorMouseController(model, view);
        FroggorMenuController menuController = new FroggorMenuController(model, view);
		FroggorPopupController popupController = new FroggorPopupController(model, view);
		
		new Timer(25, controller).start();
		
		/* start it up */
		view.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		view.setSize(982, 770);
		view.setResizable(false);
		view.setVisible(true);
		
    }


}
