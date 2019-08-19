// A class to hold a 3-D vector from a flow field.  Written by Zhenyu Guo.

public class Voxel {
	
	double pos_x, pos_y, pos_z;
	double magnitude;
	double orientation_x, orientation_y, orientation_z;
	
	Voxel(){
		
	}
	
	Voxel(double _pos_x, double _pos_y, double _pos_z, double u, double v, double w){
		this.pos_x = _pos_x;
		this.pos_y = _pos_y;
		this.pos_z = _pos_z;
		
		this.magnitude = Math.sqrt(u*u + v*v + w*w);
		
		this.orientation_x = u/this.magnitude;
		this.orientation_y = v/this.magnitude;
		this.orientation_z = w/this.magnitude;
	}
	
	
	double getMagnitude(){
		return this.magnitude;
	}
}
