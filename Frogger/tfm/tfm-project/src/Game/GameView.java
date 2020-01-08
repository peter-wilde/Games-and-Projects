package Game;


import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferStrategy;
import java.io.*;
import java.util.ArrayList;

import javax.swing.*;


public class GameView extends JFrame{

	private GameModel model;
	private GamePanel panel;
	private Frog frog;
	private JMenu froggorMenu;
	private JPopupMenu menu;
	private ArrayList<Characters> sprites = new ArrayList<>();


	/**
	 * The constructor creates the components and places them in the window.
	 * @param model the model for this Froggor game and the controller
	 */

	public GameView(GameModel m) {
		super("Froggor");
		this.model = m;
		//this.controller = c;

		// create the menu

		JMenuBar menuBar = new JMenuBar();
		setJMenuBar(menuBar);

		JMenu froggorMenu = new JMenu("Menu");
		froggorMenu.setMnemonic('M');
		menuBar.add(froggorMenu);

		JMenuItem pauseItem = new JMenuItem("Pause/Continue");
		pauseItem.setMnemonic('P');
		froggorMenu.add(pauseItem);

		JMenuItem exitItem = new JMenuItem("Exit");
		exitItem.setMnemonic('E');
		froggorMenu.add(exitItem);

		panel = new GamePanel(model, this, new File("src/Game/background2.png"));
		add(panel, BorderLayout.CENTER);
		Dimension size = panel.getSize();	

		panel.requestFocus();
	}

	public void registerListener(GameController listener) {
		panel.addKeyListener(listener);

	}

	public void registerListeners(FroggorMouseController mouse, 
			FroggorMenuController menu,
			FroggorPopupController popup) {
		panel.addMouseListener(mouse);
		panel.addMouseMotionListener(mouse);
		panel.addKeyListener(menu);
		this.addMouseListener(popup);

		Component[] components = froggorMenu.getMenuComponents();
		for (Component component : components) {
			if (component instanceof AbstractButton) {
				AbstractButton button = (AbstractButton) component;
				button.addActionListener(menu);
			}
		}

		components = froggorMenu.getComponents();
		for (Component component : components) {
			if (component instanceof AbstractButton) {
				AbstractButton button = (AbstractButton) component;
				button.addActionListener(menu);
			}
		}
	}
	public void checkForTriggerEvent(MouseEvent event) {
		if (event.isPopupTrigger()) {
			menu.show(event.getComponent(), event.getX(), event.getY()); 
		}
	}

		/*public void initSprites() {
		// create the frog and place the sprite in the center of the screen
		frog = new Frog("src/Game/FroggorSprite1.png",500,400);
		sprites.add(frog);
	}*/

}

