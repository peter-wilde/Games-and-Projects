package Game;
import java.awt.event.*;


public class FroggorPopupController extends MouseAdapter {
	
	private GameModel model;
	private GameView view;
	
	/**
	 * @param model the model of this Pong game
	 * @param view the view of this Pong game
	 */
	public FroggorPopupController(GameModel model, GameView view) {
		this.model = model;
		this.view = view;
	}
	
	/**
	 * Go back to the view object to do the pop up menu.
	 */
    public void mousePressed(MouseEvent event) { 
       view.checkForTriggerEvent(event); // check for trigger
    } // end method mousePressed

    /**
     * Go back to the view object to do the pop up menu.
     */
    public void mouseReleased(MouseEvent event) { 
       view.checkForTriggerEvent(event); // check for trigger
    } // end method mouseReleased
}

