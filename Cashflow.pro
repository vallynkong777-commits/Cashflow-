// ================== BACKEND (server.js) ================== const express = require('express'); const app = express(); const path = require('path');

app.use(express.json()); app.use(express.static('public'));

let users = []; let clicks = [];

// ===== ADMIN ===== const ADMIN = { email: "admin@cashflow.com", password: "admin123", role: "admin", links: [ "https://chariow.ly/8ZZ9HE36GM", "https://chariow.ly/7HC43UG7PG", "https://chariow.ly/K7ARCM0HGY", "https://chariow.ly/1F5WL6C1NR", "https://chariow.ly/X9EHZG0UNT" ] }; users.push(ADMIN);

// ===== REGISTER ===== app.post('/api/register', (req,res)=>{ const {email,password,link} = req.body; users.push({ email, password, link, role:'user', createdAt: Date.now(), plan:'free' }); res.json({msg:'ok'}); });

// ===== LOGIN ===== app.post('/api/login',(req,res)=>{ const user = users.find(u=>u.email===req.body.email && u.password===req.body.password); if(!user) return res.status(401).json({error:'invalid'}); res.json(user); });

// ===== PLAN CHECK ===== app.get('/api/plan/:email',(req,res)=>{ const user = users.find(u=>u.email===req.params.email); const days = (Date.now()-user.createdAt)/(10006060*24); if(days>3 && user.plan==='free') return res.json({expired:true}); res.json({expired:false}); });

// ===== TRACK CLICK ===== app.post('/api/click',(req,res)=>{ const {email,link} = req.body; clicks.push({email,link,time:Date.now()}); res.json({msg:'tracked'}); });

// ===== STATS ===== app.get('/api/stats/:email',(req,res)=>{ const userClicks = clicks.filter(c=>c.email===req.params.email); res.json({total:userClicks.length}); });

app.listen(3000,()=>console.log('Server running'));

// ================== FRONTEND (public/index.html) ================== /* Create a folder named public and inside create index.html with this content */

<!DOCTYPE html><html>
<head>
<meta charset="UTF-8">
<title>CashFlow Pro</title>
<style>
body{background:#0b0c10;color:white;font-family:Arial}
.card{background:#1c1c1c;padding:15px;margin:10px;border-radius:10px}
.btn{background:#45a29e;padding:10px;border:none;color:white;margin-top:5px}
</style>
</head>
<body><h1>💸 CashFlow PRO</h1><div class="card">
<h2>Register</h2>
<input id="rEmail" placeholder="email">
<input id="rPass" placeholder="password">
<input id="rLink" placeholder="affiliate link">
<button class="btn" onclick="register()">GO</button>
</div><div class="card">
<h2>Login</h2>
<input id="lEmail">
<input id="lPass">
<button class="btn" onclick="login()">LOGIN</button>
</div><div id="app"></div><script>
let user;

async function register(){
 await fetch('/api/register',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email:rEmail.value,password:rPass.value,link:rLink.value})});
 alert('registered');
}

async function login(){
 const res =