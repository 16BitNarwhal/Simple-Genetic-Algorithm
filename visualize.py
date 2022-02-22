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
neuron_to_color = {
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
#   if gene['source'] not in neuron_to_color:
#     g.addNode(gene['source'], 'blue')
#   else:
#     g.addNode(gene['source'], neuron_to_color[gene['source']])

#   if gene['sink'] not in neuron_to_color:
#     g.addNode(gene['sink'], 'blue')
#   else:
#     g.addNode(gene['sink'], neuron_to_color[gene['sink']])

edges = []
for gene in genome:
  # edges.append((gene['source'], gene['sink'], gene['weight']))
  g.add_edge(gene['source'], gene['sink'], weight=gene['weight'])
  
# g.add_weighted_edges_from(edges)

node_colors = []
for node in g:
  if node in neuron_to_color:
    node_colors.append(neuron_to_color[node])
  else:
    node_colors.append('yellow')

weights = []
edge_colors = []
for u, v, w in g.edges(data=True):
  weights.append(abs(w['weight'])*2)
  if w['weight'] < 0:
    edge_colors.append('red') # neg weight
  else:
    edge_colors.append('black') # pos weight

pos = nx.layout.shell_layout(g)
nx.draw_networkx_labels(g, pos)
nx.draw_networkx_nodes(g, pos, node_color=node_colors)
nx.draw_networkx_edges(g, pos, edge_color=edge_colors, width=weights)

plt.show()