import { Suspense, useRef } from "react";
import { Canvas, useFrame } from "@react-three/fiber";
import { OrbitControls, useGLTF, ContactShadows, Environment } from "@react-three/drei";
import * as THREE from "three";

const LegoModel = () => {
  const { scene } = useGLTF("/models/lego.glb");
  const ref = useRef<THREE.Group>(null);

  useFrame((_, delta) => {
    if (ref.current) {
      ref.current.rotation.y += delta * 0.3;
    }
  });

  return (
    <group ref={ref} scale={3} position={[0, -1.5, 0]}>
      <primitive object={scene} />
    </group>
  );
};

useGLTF.preload("/models/lego.glb");

const LegoModel3D = ({ className = "" }: { className?: string }) => {
  return (
    <div className={`relative ${className}`}>
      {/* Glow behind model */}
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
        <div className="h-[60%] w-[60%] rounded-full bg-primary/20 blur-[80px] animate-glow-pulse" />
      </div>
      <Canvas camera={{ position: [0, 1, 5], fov: 45 }} style={{ width: "100%", height: "100%" }}>
        <ambientLight intensity={0.5} />
        <directionalLight position={[5, 5, 5]} intensity={0.8} color="#f5c542" />
        <directionalLight position={[-3, 2, -3]} intensity={0.4} color="#2dd4bf" />
        <Suspense fallback={null}>
          <LegoModel />
          <ContactShadows position={[0, -1.2, 0]} opacity={0.4} scale={6} blur={2.5} />
          <Environment preset="city" />
        </Suspense>
        <OrbitControls enableZoom={false} enablePan={false} autoRotate={false} />
      </Canvas>
      <p className="absolute bottom-2 left-1/2 -translate-x-1/2 font-subtitle text-xs text-muted-foreground/40 pointer-events-none">
        Arrastra para girar ↻
      </p>
    </div>
  );
};

export default LegoModel3D;
