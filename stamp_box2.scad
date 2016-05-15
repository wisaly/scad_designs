/* stamp box prototype 2
 *
 * 2016/5/15
 */

sw=25;         // stamp width & height
sl=75;         // stamp length
ipd=65;        // inkpad diameter
iph=38;        // inkpad height

dt=2;          // damping pad thickness

l=100;         // length
w=sl+dt*2+20;  // width
l1h=30;        // layer 1 height
l2h=45;        // layer 2 height

module layer1(){
    cube([l,w,10]);
}

module layer2(){
    difference(){
        cube([l,w,l1h]);
        sv=[sw+dt*2,sl+dt*2,sw];
        translate([10+sv[0]/2,w/2,l1h-sv[2]/2])   cube(sv,true);
        translate([20+sv[0]/2*3,w/2,l1h-sv[2]/2]) cube(sv,true);
        //damping
        translate([10+ipd/2,w/2,0]) cylinder(d=ipd,h=dt);
    }
    
    %translate([0,0,-l2h]) cube([l,10,l2h]);
    translate([0,w-10,-l2h]) cube([l,10,l2h]);
}

module layer3(){
    difference(){
        cube([l,w,l2h]);
        d=ipd+dt*2;
        translate([10+d/2,w/2,l2h-iph+dt]) cylinder(d=d,h=iph);
        
        cube([l,10,l2h]);
        translate([0,w-10,0]) cube([l,10,l2h]);
    }
}

lkod=30;    // locker outside diameter
lkmd=20;    // locker middle diameter
lkid=40;    // locker inside diameter
lklt=5;     // locker layer thickness
// locker connect object
module lockerslot(){
    w=sqrt(lkmd*lkmd/2);
    translate([0,0,lklt/2]) cube([w,w,lklt],true);
}

// lock inside part
module lockeri(){
    difference(){
        cylinder(d=lkid,h=lklt);
        // lock
        w=(lkid-lkod)/2;
        translate([-lkid/2, -lkid/2,0]) cube([w,lkid,20]);
        translate([lkid/2-w,-lkid/2,0]) cube([w,lkid,20]);
    }
    difference(){
        translate([0,0,lklt]) cylinder(d=lkod,h=lklt);
        translate([0,0,lklt]) lockerslot();
    }
}

// locker outside part
module lockero(){
    translate([0,0,-lklt]) lockerslot();
    translate([0,0,0]) cylinder(d=lkmd,h=lklt);
    translate([0,0,lklt]) cylinder(d=lkod,h=lklt);
}

// box locker
module locker(){
    color("lightgreen") rotate([0,90,0]){
        lockeri();
        translate([0,0,20]) lockero();
    }
}


translate([0,0,100]) layer1();
layer2();
translate([150,50,15]) locker();
translate([0,0,-100]) layer3();