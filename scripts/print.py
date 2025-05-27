import csv
import sys
from matplotlib import animation
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.animation import FuncAnimation

#tmp = []
data_csv = []
with open('./chunk', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
    for row in spamreader:
        if row == []: break
        #tmp.append(row[0])
        data_csv.append(row)
        #print(row)
#cmp = list(set(tmp))

def update(slc, slic=1, dirc=0):
    cmp = []
    data = [], [], []
    # row[1] # x
    # row[2] # y
    # row[3] # z
    # 1 = 2 3
    # 2 = 1 3
    # 3 = 1 2
    
    match slic:
        case 1:
            slic_1 = 2
            slic_2 = 3
        case 2:
            slic_1 = 1
            slic_2 = 3
        case 3:
            slic_1 = 1
            slic_2 = 2

    for row in data_csv:
        if int(row[slic]) == slc:
            data[0].append(int(row[slic_2])) 
            data[1].append(int(row[slic_1]))
            if row[0] not in cmp:
                cmp.append(row[0])
            
            for i in range(len(cmp)):
                if cmp[i] == row[0]:
                    data[2].append(i)
                    break
    
    if len(data[0]) == 0: return dirc
    mxz = min(data[0])
    mxx = min(data[1])
    mxy = min(data[2])

    Mxz = max(data[0]) + abs(mxz)
    Mxx = max(data[1]) + abs(mxx)
    Mxy = max(data[2]) + abs(mxy)
   
    #XXX: problem whit slices: refactor
    Mmax = (max((Mxz, Mxx, Mxy))+1)
    matrix = [[Mmax for _ in range(Mmax+1)] for _ in range(Mmax+1)]
    for i in range(len(data[0])):
        y = data[0][i] + abs(mxx)
        x = data[1][i] + abs(mxz)
        val = data[2][i]
        matrix[x][y] = val


    px = ax.imshow(matrix, cmap='gist_ncar', interpolation='nearest', origin='lower')
    #px.imshow(matrix, cmap='tab20c', interpolation='nearest', origin='lower')

    # get the colors of the values, according to the 
    # colormap used by imshow
    colors = [ px.cmap(px.norm(value)) for value in range(len(cmp))]
    
    # create a patch (proxy artist) for every color 
    patches = [ mpatches.Patch(color=colors[i], label=cmp[i] ) for i in range(len(cmp)) ]
    # put those patched as legend-handles into the legend
    ax.legend(handles=patches, bbox_to_anchor=(1, 1), loc=2, borderaxespad=0. )
    fig.canvas.draw() 
    return 0

pos = 0
stop = 0
rot = 1
def on_press(event):
    global pos
    global stop
    global rot
    sys.stdout.flush()
    dirc = 2 
    if event.key == 'up' and stop >= 0:
        pos += 1
        dirc = -1
        stop = 0
    if event.key == 'down' and stop <= 0:
        pos -= 1
        dirc = 1
        stop = 0
    if event.key == 'right':
        if rot < 3:
            rot += 1
        else:
            rot = 1
    if event.key == 'left':
        if rot > 1:
            rot -= 1
        else:
            rot = 3
    print(f"{rot}")
    if dirc == 2: dirc = 0  
    if stop == 0:
        stop = update(pos, rot, dirc)


fig, ax = plt.subplots()
fig.canvas.mpl_connect('key_press_event', on_press)
update(0)
plt.tight_layout()
plt.show()

update(0)

