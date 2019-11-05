/**
 * Double Density Relaxation Algorithm
 * Particles Fluid Simulation
 */

/**
 * namespace
 */
var ddra = {};

ddra.$version = 0.1;

ddra.config = {
    gridResolution: 20,
    particleRadius: 20, //should <= gridResolution
    gravity: 0.1 // number or vector2
}

/*
collection              收集
particle                粒子
vector                  向量
fluid                   流體
Abstract                抽象
acceleration            加速
GRAVITY                 重力
force                   力
simulation              模擬
CELL                    細胞
Resolution              解析度
Radius                  半徑
*/