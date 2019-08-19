// A simple program to visualize the CThead volume dataset - written by Zhenyu Guo (July, 2009)
// Note: the data files must be in a subdirectory called data


import java.util.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.MemoryImageSource;
import javax.swing.*;
import java.io.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

public class VolumeSlicer {
	
	private JFrame frm;
	
	private JPanel p1;
	
	JLabel jlabel;  // some basic UI components
	JSlider jslider;
	JComboBox jcb; 
	
	SlicingVolumeData svd;  // the visualization panel
	
	//	 set volume size (fixed, for now)
	int l = 109;
	int h = 256;
	int w = 256;
	
	//	 length after interpolation (based on voxel dimensions)
	int sl =  2 * l - 1;
	
	
	// Create the UI and its components
	public VolumeSlicer() {
		
		frm = new JFrame("Volume Data Visualization");
		Container c = frm.getContentPane();
		c.setLayout(null);
		
		p1 = new JPanel();
		svd = new SlicingVolumeData();
		svd.orientation = 0;
		svd.setBounds(100,100,400,300);
		c.add(p1);
		c.add(svd);
		jslider = new JSlider(0, 100, 0); // the slider lets you select your slice
		jslider.setMaximum(255);
		jslider.addChangeListener(listener);
		jlabel = new JLabel("0");
		jcb = new JComboBox();  // the combo box lets you select your orientation
		jcb.addItem("aligned with x");
		jcb.addItem("aligned with y");
		jcb.addItem("aligned with z");
		jcb.addActionListener(new action());
		p1.add(jcb);
		p1.add(jslider);
		p1.add(jlabel);
		p1.setBounds(100,400,200,100);
	
		frm.setSize(550, 700);
		frm.setLocation(0, 0);
		frm.setVisible(true);
		frm.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);		
	}

// get the value from the slider
	ChangeListener listener = new ChangeListener() {
        public void stateChanged(ChangeEvent e) {
            if (e.getSource() == jslider) {
                int i = jslider.getValue();
                jlabel.setText(String.valueOf(i));
                svd.pos = i;
                Graphics g = svd.getGraphics();
                svd.paintComponent(g);
            }
        }
    };

// get the orientation from the combo box
    class action implements ActionListener {
		public void actionPerformed(ActionEvent e) {

			// decide which button is pressed, set maximum on slider, and set orientation
			if (e.getSource() == jcb){
				int i = jcb.getSelectedIndex();
				svd.orientation = i;
				jlabel.setText("0");
				jslider.setValue(0);
				if(i==0){
					jslider.setMaximum(w - 1);
				}else if (i==1){
					jslider.setMaximum(h - 1);
				}else if(i==2){
					jslider.setMaximum(sl - 1);
				} 
				Graphics g = svd.getGraphics();
                svd.paintComponent(g);
			}								
		}
	}
  
// Start it up
    public static void main(String[] args) {
    	try {
    		new VolumeSlicer();
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
}

// The class for visualizing slices of a volume
class SlicingVolumeData extends JPanel {

	int[] pixels;  // the pixels for the display

	short[][][] scaleValues; // the values after scaling

	short[][] sliceImage; // a slice of the data

	//	 set volume size
	int l = 109;
	int h = 256;
	int w = 256;
	int sl = 2 * l - 1;

	//	 three orientations for a cut slice
	//	 acceptable value: 0, 1 or 2 
	int orientation;

	//	 the cut slice position
	int pos = 0;

	// gray pixel value
	short gray;

	//	 the displayed picture
	Image pic;

	boolean draw1, draw2;
	// need range to normalize the data
	int min = 10000000;
	int max = -10000;

	SlicingVolumeData() {
		Read();
	}
	

	//	 how to paint the visualization
	public void paintComponent(Graphics g) {
		clear(g);
		Graphics2D g2d = (Graphics2D) g;

		pixels = new int[256 * 256];  // allocate the image
		
// for each orientation, go through the scaled data and pack value into a grey scale
		if (orientation == 0) {
			for (int i = 0; i < sl; i++) {
				for (int j = 0; j < w; j++) {
					gray = scaleValues[i][pos][j];
					pixels[i * w + j] = 0xFF000000 | (gray << 16)
					| (gray << 8) | gray;
					
				}
			}
		} else if (orientation == 1) {
			for (int i = 0; i < sl; i++) {
				for (int j = 0; j < h; j++) {
					gray = scaleValues[i][j][pos];
					pixels[i * w + j] = 0xFF000000 | (gray << 16)
							| (gray << 8) | gray;
				}
			}
		}else if (orientation == 2) {
			for (int i = 0; i < h; i++) {
				for (int j = 0; j < w; j++) {
					gray = scaleValues[pos][i][j];
					pixels[i * w + j] = 0xFF000000 | (gray << 16)
							| (gray << 8) | gray;
				}
			}
		} 
//load the image and draw it
		pic = createImage(new MemoryImageSource(w, h, pixels, 0, w));
		g2d.drawImage(pic, 0, 0, this);

	}

// read in the data from the CThead.* datasets
	void Read() {
		short[][][] values;  // array to hold values
		String s = "data/MRbrain.";
		values = new short[l][h][w];
		int v;
		try {
			//start reading all files
			for (int i = 0; i < 109; i++) {
				File f = new File(s + String.valueOf(i + 1));
				System.out.println("reading: " + s + String.valueOf(i + 1));
				if (!f.exists()) {
					System.out.println(s + String.valueOf(i + 1) + "does't exist");
				}
				FileInputStream inputStream = new FileInputStream(f);

				int j = 0;
				int k = 0;
				//	read a single file, alternating high order and low order bytes
				
				int flag = 0;  // keep track of which byte you're reading
				while ((v=inputStream.read()) != -1) {
					
					if(flag%2==0){
						// read the higher byte
						values[i][j][k] = (short) v;
						flag++;
					}else{
						// read the lower byte
						int pv = values[i][j][k];
						
						v = pv<<8 | v;  // combine bytes and store
						values[i][j][k] = (short) v;
						k++;
						flag--;
					}
			// at end of row, reset k
					if (k == 256) {
						k = 0;
						j++;
						flag = 0;
					}
				
				}

			}

			scaleValues = new short[sl][h][w];  // we store the scaled data in this array

			//interpolated volume data (from 1:1:2 to 1:1:1)
			for (int i = 0; i < l; i++) {
				for (int j = 0; j < w; j++) {
					for (int k = 0; k < h; k++) {
						scaleValues[i * 2][j][k] = values[i][j][k];
					}
				}
			}

			for (int i = 1; i < l; i++) {
				for (int j = 0; j < w; j++) {
					for (int k = 0; k < h; k++) {
						scaleValues[i * 2 - 1][j][k] = (short) ((values[i - 1][j][k] + values[i][j][k]) / 2);
					}
				}
			}
			
			
			// get minimum and maximum value for this dataset
			for (int i = 0; i < sl; i++) {
				for (int j = 0; j < w; j++) {
					for (int k = 0; k < h; k++) {
						if(min>scaleValues[i][j][k]){
							min = scaleValues[i][j][k];
						}
						if(max<scaleValues[i][j][k]){
							max = scaleValues[i][j][k];
						}
					}
				}
			}
			
			//scale the data values into 8-bit
			for (int i = 0; i < sl; i++) {
				for (int j = 0; j < w; j++) {
					for (int k = 0; k < h; k++) {
						int value = scaleValues[i][j][k];
						value = (int)((double)((value - min)*255)/(double)(max-min));
						scaleValues[i][j][k] = (short)value;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	void clear(Graphics g) {
		super.paintComponent(g);
	}
}


