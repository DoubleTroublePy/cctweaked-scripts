use std::process::Command;
use std::fs::File;
use std::io::Read;

fn random(min: u8, max: u8) -> u8 {
    let mut f = File::open("/dev/urandom").unwrap();
    let mut buf = [0u8; 1];
    f.read_exact(&mut buf).unwrap();
    buf[0]%(max+1)+min
}

fn mat_print(mat: Vec<Vec<u8>>, active:(usize, usize) ) {
    let dim = mat.len();
    assert!(dim > 0);
    assert!(mat[0].len() == dim);
    
    let (x, y) = active;

    for j in (0..dim).step_by(2) {
        for i in 0..dim {
            let mut act = 0;
            if i == x && j == y {
                act = 1;
            } else if i == x && j+1 == y {
                act = 2;
            }

            if act != 0 {
                print!("\x1b[31m");
            }
            
            // TODO: if matrix is odd dont exit the bounds
            if mat[j][i] == 0 && mat[j+1][i] == 1 {
                print!("▄");
            } else if mat[j][i] == 1 && mat[j+1][i] == 0 {
                print!("▀");
            } else if mat[j][i] == 1 && mat[j+1][i] == 1 {
                if act != 0 {
                    print!("\x1b[107m");
                }
                if act == 1 {
                    print!("▀");
                } else if act == 2 {
                    print!("▄");
                } else{
                    print!("█");
                }
            } else {
                print!(" ");
            }
            print!("\x1b[0m");
        }
        println!("");
    }
}

fn main() {
    let dim = 25;
    
    loop {
    let mut active: (usize, usize) = (
            random(0, (dim-1).try_into().unwrap()).into(),
            random(0, (dim-1).try_into().unwrap()).into()
    );
    println!("{:?}", active);

    let mut mat: Vec<Vec<u8>> = vec![vec![0; dim]; dim];

    for i in 0..dim {
        for j in 0..dim {
            mat[j][i] = random(0, 1);
        }
    }
    
    mat[active.0][active.1] = 1;
    mat_print(mat, active);
    

    let mut child = Command::new("sleep").arg("1").spawn().unwrap();
    let _result = child.wait().unwrap();

    print!("{}[2J", 27 as char);
    print!("{esc}[2J{esc}[1;1H", esc = 27 as char);
    }
}
