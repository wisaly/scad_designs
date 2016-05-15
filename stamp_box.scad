/* stamp box for shiky's marriage
 * 
 * bouding size 350 * 170 * 100
 */
biL = 330;      // box inner length
biW = 150;      // box inner width
biH = 100;      // box inner height
stampL = 80;    // stamp length
stampW = 25;    // stamp width & height
stampPH=10;      // stamp platform height
ipD = 65;       // inkpad diameter
ipH = 38;       // inkpad height
objB = 5;       // object bare height
bt = 10;        // bt thickness
trW=5;          // track with
drH=15;         // dark room height
drW=50;         // dark room width
drOY=25;        // dark room offset
drcL=85;       // dark room cap length
ubOX=10;        // union bar offset x
ubOY=10;        // union bar offset y
ubW=15;         // union bar width
ubH=55;         // union bar height
lkD=70;         // locker diameter(large side)
lkaD=30;        // locker axis diameter
lksD=50;        // locker strip diameter
l1H=bt;         // layer 1 height
l2H=40;         // layer 2 height
l3H=20;         // layer 3 height
l4H=bt;         // layer 4 height
l1tH=l1H-trW;   // layer 1 tenon height
l2tH=bt;        // layer 2 tenon height
l3tH=10;        // layer 3 tenon height
l1tOZ=5;      // layer 1 tenon offset z
l2tOZ=25;       // layer 2 tenon offset z
l2L=biL-bt*3;   // layer 2 main length
l3L=200;        // layer 3 length

// stamp hole
module stampHole(){
    cube([stampL,stampW,stampW-objB+stampPH]);
    translate([10,0,0]) cube([stampL-20,stampW,40]);
}

module stampPlatform(){
    cube([stampL,stampW,stampPH]);
    h=20;
    translate([10,0,-h]) cube([stampL-20,stampW,h]);
}

// union bar
module unionbar(h,l){
    color("red") difference(){
        cube([l,ubW,h]);
        translate([l-ubW,0,h-ubW]) rotate([-90,180,0]) linear_extrude(ubW) polygon([[0,0],[ubW+1,ubW+1],[l-ubW*3-1,ubW+1],[l-ubW*2,0]]);
    }
}

// union bar locker (triangle)
module ublocker(toleft=false){
    translate([0,ubW,0]) rotate([-90,180,180]) linear_extrude(ubW) polygon([[0,0],[ubW,ubW],[ubW*2,ubW],[ubW*3,0]]);
}

// 2nd lock slot (2 rotate cube)
module lock2slot(h=bt){
    rotate([0,0,20]) translate([-5,-35,0]) cube([bt,20,h]);
    rotate([0,0,-20]) translate([-5,15,0]) cube([bt,20,h]);
}

// locker connect object
module lockerslot(){
    w=sqrt(lkaD*lkaD/2);
    translate([0,0,bt/2]) cube([w,w,bt],true);
}

// lock left part (inside)
module lockerl(){
    difference(){
        cylinder(d=lkD,h=bt);
        // lock1
        translate([-lkD/2,-lkD/2,0]) cube([bt,lkD,20]);
        // lock2
        rotate(180,0,0) lock2slot();
        // positioner
        lock2slot(2);
    }
    difference(){
        translate([0,0,bt]) cylinder(d=50,h=bt);
        translate([0,0,bt]) lockerslot();
    }
}

// locker right part (outside)
module lockerr(){
    translate([0,0,-bt]) lockerslot();
    translate([0,0,0]) cylinder(d=lkaD,h=bt);
    translate([0,0,bt]) cylinder(d=50,h=bt);
}

// box locker
module locker(){
    color("lightgreen") rotate([0,90,0]){
        lockerl();
        translate([0,0,bt*2+20]) lockerr();
    }
}

// locker in on module (old design)
module lockero(){
    color("lightgreen") rotate([0,90,0]){
        difference(){
            cylinder(d=lkD,h=bt);
            // lock1
            translate([-lkD/2,-lkD/2,0]) cube([bt,lkD,20]);
            // lock2
            rotate(180,0,0) lock2slot();
            // positioner
            lock2slot(2);
        }
        translate([0,0,bt]) cylinder(d=50,h=bt);
        translate([0,0,bt*2]) cylinder(d=lkaD,h=bt);
        translate([0,0,bt*3]) cylinder(d=50,h=bt);
    }
}


module layer1(){
    difference(){
        cube([biL+bt,biW,l1H]);
        // lock slot
        translate([biL-bt*2,(biW-lkD)/2,0]) cube([bt,lkD,trW]);
        // lock slot 2
        translate([115,(biW-lkD)/2,0]) cube([bt,lkD,trW]);
    }
    
    // union bar pusher
    ubpOX=30;
    translate([ubpOX,ubOY,-ubW])         ublocker();
    translate([ubpOX,biW-ubOY-ubW,-ubW]) ublocker();
    
    // tenon
    translate([0,-trW,0]) cube([biL+bt,trW,l1tH]);
    translate([0,biW,0])  cube([biL+bt,trW,l1tH]);
}
// layer 2 connect object
module layer2slot(){
    // middle
    translate([0,35,10])     cube([10,10,20]);
    translate([0,biW-45,10]) cube([10,10,20]);
    // side
    //translate([10,trW,l2tH+l2tOZ]) rotate([180,90,0]) linear_extrude(10) polygon([[0,0],[l2tH,l2tH],[l2tH*2,l2tH],[l2tH*3,0]]);
    translate([0,-trW,l2tOZ-l2tH])    cube([10,l2tH,l2tH]);
    translate([0,biW-trW,l2tOZ-l2tH]) cube([10,l2tH,l2tH]);
    
    translate([5,trW,0])            cube([5,5,10]);
    translate([5,trW,l2H-10])       cube([5,5,10]);
    translate([5,biW-trW*2,0])      cube([5,5,10]);
    translate([5,biW-trW*2,l2H-10]) cube([5,5,10]);
}

// layer 2 left part
module layer2l(){
    mirror([0,0,1]) union(){
        difference(){
            cube([drcL,biW,l2H]);
            // inkpad hole
            ipOX = ipD/2+10;
            ipOY = (biW - ipD) / 2;
            translate([ipOX,ipOY+ipD/2,0]) cylinder(d=ipD,h=ipH-objB);
            // union bar hole
            ubhW=l2L-ubOX*2;
            translate([ubOX,ubOY,0]) cube([ubhW,ubW,drcL]);
            translate([ubOX,biW-ubOY-ubW,0]) cube([ubhW,ubW,drcL]);
            // slot
            translate([drcL-10,0,0]) layer2slot();
        }
    }
    // tenon
    translate([-trW,0,-l2tOZ]) cube([trW,biW,l2tH]);
    //translate([0,-trW,-tOZ]) cube([bt,trW,l2tH]);
    //translate([0,biW,-tOZ]) cube([lbt,trW,l2tH]);
}

module layer2r(){
    mirror([0,0,1]) union(){
        difference(){
            cube([l2L-drcL,biW,l2H]);
            // stamp hole
            sOX = 10;  // 20 between inkpad and stamp
            sOY = (biW-stampW*2-20)/2; // 20 between two stamps
            translate([sOX,sOY,0]) stampHole();
            translate([sOX,biW-sOY-stampW,0]) stampHole();
            // union bar hole
            ubhW=l2L-ubOX-drcL;
            translate([0,ubOY,0]) cube([ubhW,ubW,l2H]);
            translate([0,biW-ubOY-ubW,0]) cube([ubhW,ubW,l2H]);
        }
        translate([-10,0,0]) layer2slot();
    }
    // tenon
    translate([0,-trW,-l2tOZ]) cube([l2L-drcL+bt,trW,l2tH]);
    translate([0,biW,-l2tOZ]) cube([l2L-drcL+bt,trW,l2tH]);
    // lock tenon
    translate([l2L-drcL,0,-l2H]) difference(){
        cube([bt,biW,l2H]);
        translate([0,biW/2,l2H/2+5]) rotate([0,90,0]) cylinder(d=lkD,h=bt+10);
    }
    translate([l2L-drcL,75,-15]) rotate([0,90,0]) lock2slot();
}

module layer2(){
    layer2l();
    translate([drcL,0,0]) layer2r();
}
module layer2o(){
    // layer plane, base below (xy)
    mirror([0,0,1]) union(){
        difference(){
            cube([l2L,biW,l2H]);
            // inkpad hole
            ipOX = ipD/2+10;
            ipOY = (biW - ipD) / 2;
            translate([ipOX,ipOY+ipD/2,0]) cylinder(d=ipD,h=ipH-objB);
            // stamp hole
            sOX = ipOX+ipD/2+20;  // 20 between inkpad and stamp
            sOY = (biW-stampW*2-20)/2; // 20 between two stamps
            translate([sOX,sOY,0]) stampHole();
            translate([sOX,biW-sOY-stampW,0]) stampHole();
            // union bar hole
            ubhW=l2L-ubOX*2;
            translate([ubOX,ubOY,0]) cube([ubhW,ubW,l2H]);
            translate([ubOX,biW-ubOY-ubW,0]) cube([ubhW,ubW,l2H]);
        }
    }
    // tenon
    tOZ=20;
    translate([-trW,0,-tOZ]) cube([trW,biW,l2tH]);
    translate([drcL,-trW,-tOZ]) cube([l2L-drcL,trW,l2tH]);
    translate([drcL,biW,-tOZ]) cube([l2L-drcL,trW,l2tH]);
    // lock tenon
    color("green") translate([l2L,75,-5]) rotate([0,90,0]) lock2slot();
}

module layer3(){
    sO=50;  // slope offset
    sH=10;  // slop height
    sW=130;  // slop width
    
    // layer plane, base below (xy)
    mirror([0,0,1]) union(){
        difference(){
            cube([l3L,biW,l3H]);
            translate([sO,biW-ubOY-ubW,0]) rotate([90,0,0]) linear_extrude(biW-ubOY*2-ubW*2) polygon([[0,0],[sW,0],[sW,sH]]);
            translate([sO+sW,ubOY+ubW,0]) cube([l3L-sW-sO,biW-ubOY*2-ubW*2,sH]);
            
            // union bar hole
            translate([ubOX,ubOY,         -sH]) cube([l3L-ubW*2,ubW,l3H]);
            translate([ubOX,biW-ubOY-ubW, -sH]) cube([l3L-ubW*2,ubW,l3H]);
            
            //translate([0,50]) cube([l3L,30,l3H]);
            // dark room
            translate([0,drOY,l3H-drH]) cube([drW,biW-drOY*2,drH]);
        }
    }
    // union bar, base on (xy)
    translate([ubOX,ubOY,        50-sH]) unionbar(ubH+bt,l3L-ubW*2);
    translate([ubOX,biW-ubOY-ubW,50-sH]) unionbar(ubH,l3L-ubW*2);
    
    // tenon
    translate([0,-trW,-l3H]) cube([l3L,trW,l3tH]);
    translate([0,biW,-l3H])  cube([l3L,trW,l3tH]);
}

module layer4(){
    difference(){
        cube([biL,biW,l4H]);
        translate([0,drOY+bt,5]) cube([drW-bt,biW-drOY*2-bt*2,5]);
    }
    // dark room field
    color("lightblue"){
        translate([0,drOY,l4H]) cube([drW,bt,drH]);
        translate([0,biW-drOY-bt,l4H]) cube([drW,bt,drH]);
        translate([drW-bt,drOY+bt,l4H]) cube([bt,biW-drOY*2-bt*2,drH]);
    }
    
    translate([-bt,0,0]) difference(){
        cube([bt,biW,bt]);
        yslotl();
    }
    translate([biL,0,0]) difference(){
        cube([bt,biW,bt]);
        yslotr();
    }
}

module yslotl(){
    difference(){
        cube([bt,biW,bt]);
        translate([0,0,0]) cube([bt,25,bt]);
        translate([0,biW-25,0]) cube([bt,25,bt]);
        translate([0,55,0]) cube([bt,40,5]);
    }
}

module yslotr(){
    difference(){
        cube([bt,biW,bt]);
        translate([0,25,0]) cube([bt,30,bt]);
        translate([0,biW-55,0]) cube([bt,30,bt]);
    }
}

// z axis slot for right side
module zslotr(){
    difference(){
        cube([bt,bt,biH]);
        translate([0,0,0]) cube([bt,bt,25]);
        translate([0,0,50]) cube([bt,bt,10]);
        //translate([0,0,90]) cube([bt,bt,10]);
    }
}
module zslotl(){
    difference(){
        cube([bt,bt,biH]);
        translate([0,0,10]) cube([bt,bt,15]);
        translate([0,0,40]) cube([bt,bt,10]);
        translate([0,0,60]) cube([bt,bt,10]);
        translate([0,0,80]) cube([bt,bt,20]);
    }
}

module layerF(){
    mirror([0,1,0]) layerB();
}

// layer back
module layerB(){
    difference(){
        union(){
            cube([biL,bt,biH]);
            translate([-bt,0,0]) zslotl();
            translate([biL,0,0]) zslotr();
        }
        l3sH=5;    // layer 3 slot space height
        translate([0,0,bt])                        cube([biL,trW,l3tH+l3sH]);
        translate([drcL-bt,0,l4H+l3H+l3sH+l2H-l2tOZ]) cube([biL-drcL+bt,trW,l2tH]);
        translate([-bt,0,biH-l1tOZ-l1tH])          cube([biL+bt*2,trW,l1tH]);
    }
}

module layerL(){
    translate([0,0,bt]) difference(){
        cube([bt,biW,biH-bt]);
        l3sH=5;    // layer 3 slot space height
        translate([trW,0,l4H+l3H+l3sH+l2H-l2tOZ-bt]) cube([trW,biW,l2tH]);
    }
    // border
    yslotl();
    translate([0,-bt,0]) difference(){
        cube([bt,bt,biH]);
        zslotl();
    }
    translate([0,biW,0]) difference(){
        cube([bt,bt,biH]);
        zslotl();
    }
}

module layerR(){
    translate([0,0,bt]) difference(){
        cube([bt,biW,biH-bt*2]);
        translate([0,biW/2,biH-bt*2-l1tH-lksD/2]) rotate([0,90,0]) cylinder(d=lkaD,h=bt+1);
    }
    
    yslotr();
    translate([0,-bt,0]) difference(){
        cube([bt,bt,biH-bt]);
        zslotr();
    }
    translate([0,biW,0]) difference(){
        cube([bt,bt,biH-bt]);
        zslotr();
    }
}

// move to end position
//translate([190,0,310]) layer1();
//translate([0,0,300]) layer2();
//translate([110,0,255]) layer3();

// move to stamp position
//translate([105,0,310]) layer1();
//translate([25,0,255]) layer3();

// combination position
//translate([165,0,90]) layer1();
//translate([0,0,75]) layer2();
//translate([90,0,30]) layer3();

// split position
translate([0,0,415]) layer1();
translate([0,0,300]) layer2l();
translate([drcL+0,0,300]) layer2r();
translate([drcL+10,40,350])stampPlatform();
translate([0,0,105]) layer3();
layer4();
%translate([0,-100,0]) layerF();
translate([0,160,0]) layerB();
translate([-120,0,0]) layerL();
translate([380,0,0]) layerR();

translate([493,75,60])rotate([180,0,0]) locker();