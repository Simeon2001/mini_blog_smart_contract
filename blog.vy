# @version >=0.2

latestpostid: public(uint256)


struct User:
    username: String[32]
    bio: String[200]
    postid: DynArray[uint256, 8000]

struct Post:
    title: String[100]
    content: String[20000]
    author: address
    created: uint256

users: public(HashMap[address,User])
posts: public(HashMap[uint256,Post])

event newpost:
    title: String[100]
    content: String[20000]
    author: address
    created: uint256

owner: address

@external
def __init__():
    self.latestpostid = 0
    self.owner = msg.sender

@external
def createpost(title:String[100],content:String[20000]):
    self.latestpostid += 1
    self.posts[self.latestpostid] = Post({title:title,content:content,author:msg.sender,created:block.timestamp})
    self.users[msg.sender].postid.append(self.latestpostid)
    log newpost(title,content,msg.sender,block.timestamp)

@external
def updateUsername(username:String[32]):
    self.users[msg.sender].username = username

@external
def updatebio(bio:String[200]):
    self.users[msg.sender].bio = bio

@view
@external
def get_post_id_by_author(author:address) -> DynArray[uint256,8000]:
    return self.users[author].postid

@view
@external
def get_post_by_id(id:uint256) -> Post:
    return self.posts[id]