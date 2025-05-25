import csv
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

tmp = []
data_csv = []
with open('./chunk.csv', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
    for row in spamreader:
        tmp.append(row[0])
        data_csv.append(row)
        #print(row)
cmp = list(set(tmp))

data = [], [], []
for row in data_csv:
    if int(row[3]) == 0:
        data[0].append(int(row[1])) 
        data[1].append(int(row[2]))
        for i in range(len(cmp)):
            if cmp[i] == row[0]:
                data[2].append(i)
                break

mxz = min(data[0])
mxx = min(data[1])
Mxz = max(data[0]) + abs(mxz)
Mxx = max(data[1]) + abs(mxx)

matrix = mat = [[-1 for _ in range(Mxz+1)] for _ in range(Mxx+1)]
for i in range(len(data[0])):
    y = data[0][i] + abs(mxx)
    x = data[1][i] + abs(mxz)
    val = data[2][i]
    matrix[x][y] = val

px = plt.figure()

px = plt.imshow(matrix, cmap='tab20c', interpolation='nearest', origin='lower')

# get the colors of the values, according to the 
# colormap used by imshow
colors = [ px.cmap(px.norm(value)) for value in range(len(cmp))]
# create a patch (proxy artist) for every color 
patches = [ mpatches.Patch(color=colors[i], label=cmp[i] ) for i in range(len(cmp)) ]
# put those patched as legend-handles into the legend
plt.legend(handles=patches, bbox_to_anchor=(1, 1), loc=2, borderaxespad=0. )
plt.tight_layout()
plt.show()

