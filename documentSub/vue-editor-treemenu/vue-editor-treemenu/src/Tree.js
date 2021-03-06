// used to record treenode's change
let Record = {}
// treenode's id
let nodeId = 1

/**
 * Tree data struct
 * Created by ayou on 2017/7/20.
 * @param name: treenode's name
 * @param isLeaf: treenode is leaf node or not
 * @param id
 */
const TreeNode = function (name, isLeaf, id, ptype, pidNode, folder_icon) {
  this.name = name
  this.id = (typeof id === 'undefined') ? ('new' + nodeId++) : id
  this.parent = null
  this.pid = null
  this.children = null
  this.isLeaf = !!isLeaf
  this.ptype = ptype
  this.pidNode = pidNode
  this.folder_icon = folder_icon
}

TreeNode.prototype.updateRecordProperty = function () {
  if (!Record[this.id]) {
    Record[this.id] = {}
  }

  Record[this.id].name = this.name
  Record[this.id].id = this.id
  Record[this.id].pid = this.pid
  Record[this.id].isLeaf = this.isLeaf
  Record[this.id].ptype = this.ptype
  Record[this.id].pidNode = this.pidNode
  Record[this.id].folder_icon = this.folder_icon
}

TreeNode.prototype.changeName = function (name) {
  this.name = name

  this.updateRecordProperty()
  Record[this.id].modify = true
}

TreeNode.prototype.addChildren = function (children, isNew) {
  if (!this.children) {
    this.children = []
  }

  if (Array.isArray(children)) {
    for (let i = 0, len = children.length; i < len; i++) {
      const child = children[i]
      child.parent = this
      child.pid = this.id
      child.ptype = child.ptype
      child.pidNode = child.pidNode
      child.folder_icon = child.folder_icon
      if (isNew) {
        child.updateRecordProperty()
        Record[child.id].add = true
      }
    }
    this.children.concat(children)
  } else {
    const child = children
    child.parent = this
    child.pid = this.id
    child.ptype = child.ptype
    child.pidNode = child.pidNode
    child.folder_icon = child.folder_icon
    
    this.children.push(child)

    if (isNew) {
      child.updateRecordProperty()
      Record[child.id].add = true
    }
  }
}

// remove self
TreeNode.prototype.remove = function () {
  const parent = this.parent
  const index = parent.findChildIndex(this)
  parent.children.splice(index, 1)

  this.updateRecordProperty()
  Record[this.id].remove = true
}

// remove child
TreeNode.prototype._removeChild = function (child) {
  for (var i = 0, len = this.children.length; i < len; i++) {
    if (this.children[i] === child) {
      this.children.splice(i, 1)
      break
    }
  }
}

TreeNode.prototype.isTargetChild = function (target) {
  let parent = target.parent
  while (parent) {
    if (parent === this) {
      return true
    }
    parent = parent.parent
  }
  return false
}

TreeNode.prototype.moveInto = function (target) {
  if (this.name === 'root' || this === target) {
    return
  }

  // cannot move ancestor to child
  if (this.isTargetChild(target)) {
    return
  }

  // cannot move to leaf node
  if (target.isLeaf) {
    return
  }

  this.parent._removeChild(this)
  this.parent = target
  this.pid = target.id
  this.ptype = target.ptype
  this.pidNode = target.pidNode
  this.folder_icon = target.folder_icon
  
  if (!target.children) {
    target.children = []
  }
  target.children.unshift(this)

  this.updateRecordProperty()
  Record[this.id].targetId = target.id
  Record[this.id].move = true
  Record[this.id].moveType = 'inside'
}

TreeNode.prototype.findChildIndex = function (child) {
  var index
  for (let i = 0, len = this.children.length; i < len; i++) {
    if (this.children[i] === child) {
      index = i
      break
    }
  }
  return index
}

TreeNode.prototype._beforeInsert = function (target) {
  if (this.name === 'root' || this === target) {
    return false
  }

  // cannot move ancestor to child
  if (this.isTargetChild(target)) {
    return false
  }

  this.parent._removeChild(this)
  this.parent = target.parent
  this.pid = target.parent.id
  this.ptype = target.ptype
  this.pidNode = target.pidNode
  this.folder_icon = target.folder_icon
  
  return true
}

TreeNode.prototype.insertBefore = function (target) {
  if (!this._beforeInsert(target)) return

  const pos = target.parent.findChildIndex(target)
  target.parent.children.splice(pos, 0, this)

  this.updateRecordProperty()
  Record[this.id].targetId = target.id
  Record[this.id].move = true
  Record[this.id].moveType = 'before'
}

TreeNode.prototype.insertAfter = function (target) {
  if (!this._beforeInsert(target)) return

  const pos = target.parent.findChildIndex(target)
  target.parent.children.splice(pos + 1, 0, this)

  this.updateRecordProperty()
  Record[this.id].targetId = target.id
  Record[this.id].move = true
  Record[this.id].moveType = 'after'
}

function Tree(data) {
  this.root = new TreeNode('root', false, 0, 0, 'folder')
  this.initNode(this.root, data)
  return this.root
}

Tree.prototype.initNode = function (node, data) {
  for (let i = 0, len = data.length; i < len; i++) {
    var _data = data[i]
    var child = new TreeNode(_data.name, _data.isLeaf, _data.id, _data.ptype, _data.pidNode, _data.folder_icon)
    if (_data.children && _data.children.length > 0) {
      this.initNode(child, _data.children)
    }
    node.addChildren(child)
  }
}

exports.Tree = Tree
exports.TreeNode = TreeNode
exports.Record = Record
