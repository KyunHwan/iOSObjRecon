import MetalKit

struct Mesh {
    var vertexBuffers: [MTLBuffer]
    var submeshes: [Submesh]
}

extension Mesh {
    init(mdlMesh: MDLMesh, mtkMesh: MTKMesh) {
        var vertexBuffers: [MTLBuffer] = []
        for mtkMeshBuffer in mtkMesh.vertexBuffers {
            vertexBuffers.append(mtkMeshBuffer.buffer)
        }
        self.vertexBuffers = vertexBuffers
        
        //print("mdlMesh.submeshes!.count = \(mdlMesh.submeshes!.count)")
        //print("mtkMesh.submeshes.count = \(mtkMesh.submeshes.count)")
        
        submeshes = zip(mdlMesh.submeshes!, mtkMesh.submeshes).map { mesh in
            Submesh(mdlSubmesh: mesh.0 as! MDLSubmesh, mtkSubmesh: mesh.1)
        }
        
        //print("submeshes.count = \(submeshes.count)")
    }
}
