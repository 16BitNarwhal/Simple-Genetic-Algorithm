# for fetching data
import json
import random

# for visualizing data
import networkx as nx
import matplotlib.pyplot as plt 

SAVE_DIR = './saves/'
FILE_NAME = 'simple_109'

with open(SAVE_DIR + FILE_NAME + '.json', 'r') as f:
  data = json.load(f)

pop = data['population']

genome = random.choice(pop)['genome']

nodes = ()
neuron_to_colour = {
  'sensePosX': '#32CD32',
  'sensePosY': '#32CD32',
  'senseOsc': '#32CD32',
  'senseRand': '#32CD32',
  'lastMoveX': '#32CD32',
  'lastMoveY': '#32CD32',
  'senseMemory': '#32CD32',
  'moveX': '#ADD8E6',
  'moveY': '#ADD8E6',
  'outMemory': '#ADD8E6'
}

g = nx.DiGraph() 
    
# for gene in genome:
#   if gene['source'] not in neuron_to_colour:
#     g.addNode(gene['source'], 'blue')
#   else:
#     g.addNode(gene['source'], neuron_to_colour[gene['source']])

#   if gene['sink'] not in neuron_to_colour:
#     g.addNode(gene['sink'], 'blue')
#   else:
#     g.addNode(gene['sink'], neuron_to_colour[gene['sink']])

edges = []
for gene in genome:
  edges.append((gene['source'], gene['sink'], gene['weight']))

  if gene['source'] == 'hidden1' or gene['source'] == 'hidden2' \
    or gene['source'] == 'hidden3' or gene['source'] == 'hidden0':
    print(gene['sink'])
  
g.add_weighted_edges_from(edges)

color_map = []
for node in g:
  if node in neuron_to_colour:
    color_map.append(neuron_to_colour[node])
  else:
    color_map.append('yellow')

# i dont know why its not showing weights
# also graph really ugly
nx.draw_networkx(g, node_color=color_map, with_labels=True)
plt.show()