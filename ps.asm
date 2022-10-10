
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define HEADER "\nPID\tName         UID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n"
#endif

int
main(int argc, char * argv[])		
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 24             	sub    $0x24,%esp
  18:	8b 41 04             	mov    0x4(%ecx),%eax
  int max;
  max = atoi(argv[1]);
  1b:	ff 70 04             	pushl  0x4(%eax)
  1e:	e8 b8 02 00 00       	call   2db <atoi>
  23:	89 c3                	mov    %eax,%ebx

  struct uproc * table; 
  table =  (struct uproc *)  malloc(max * sizeof(struct uproc));	
  25:	8d 04 40             	lea    (%eax,%eax,2),%eax
  28:	c1 e0 05             	shl    $0x5,%eax
  2b:	89 04 24             	mov    %eax,(%esp)
  2e:	e8 ad 07 00 00       	call   7e0 <malloc>
  33:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int get = getprocs(max, table); 
  36:	83 c4 08             	add    $0x8,%esp
  39:	50                   	push   %eax
  3a:	53                   	push   %ebx
  3b:	e8 b6 04 00 00       	call   4f6 <getprocs>
  40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(get == -1)
  43:	83 c4 10             	add    $0x10,%esp
  46:	83 f8 ff             	cmp    $0xffffffff,%eax
  49:	74 16                	je     61 <main+0x61>
    printf(1, "Error\n");
  
  if(get>-1)
  4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  4f:	79 24                	jns    75 <main+0x75>
      printf(1, "%s\t%d\n", table[i].state, table[i].size);
    }
    printf(1, "\n");
  }

  free(table);
  51:	83 ec 0c             	sub    $0xc,%esp
  54:	ff 75 d8             	pushl  -0x28(%ebp)
  57:	e8 c0 06 00 00       	call   71c <free>
  exit();
  5c:	e8 bd 03 00 00       	call   41e <exit>
    printf(1, "Error\n");
  61:	83 ec 08             	sub    $0x8,%esp
  64:	68 6c 08 00 00       	push   $0x86c
  69:	6a 01                	push   $0x1
  6b:	e8 3f 05 00 00       	call   5af <printf>
  70:	83 c4 10             	add    $0x10,%esp
  73:	eb d6                	jmp    4b <main+0x4b>
    printf(1, HEADER);
  75:	83 ec 08             	sub    $0x8,%esp
  78:	68 a0 08 00 00       	push   $0x8a0
  7d:	6a 01                	push   $0x1
  7f:	e8 2b 05 00 00       	call   5af <printf>
    for(i = 0; i < get; ++i)
  84:	83 c4 10             	add    $0x10,%esp
  87:	bf 00 00 00 00       	mov    $0x0,%edi
  8c:	e9 d7 00 00 00       	jmp    168 <main+0x168>
      printf(1, "%d\t%s\t\t%d\t%d\t%d\t", table[i].pid, table[i].name, table[i].uid, table[i].gid, table[i].ppid);
  91:	8d 1c 7f             	lea    (%edi,%edi,2),%ebx
  94:	c1 e3 05             	shl    $0x5,%ebx
  97:	03 5d d8             	add    -0x28(%ebp),%ebx
  9a:	8d 43 40             	lea    0x40(%ebx),%eax
  9d:	83 ec 04             	sub    $0x4,%esp
  a0:	ff 73 0c             	pushl  0xc(%ebx)
  a3:	ff 73 08             	pushl  0x8(%ebx)
  a6:	ff 73 04             	pushl  0x4(%ebx)
  a9:	50                   	push   %eax
  aa:	ff 33                	pushl  (%ebx)
  ac:	68 73 08 00 00       	push   $0x873
  b1:	6a 01                	push   $0x1
  b3:	e8 f7 04 00 00       	call   5af <printf>
      printf(1, "%d\t", table[i].priority);
  b8:	83 c4 1c             	add    $0x1c,%esp
  bb:	ff 73 10             	pushl  0x10(%ebx)
  be:	68 80 08 00 00       	push   $0x880
  c3:	6a 01                	push   $0x1
  c5:	e8 e5 04 00 00       	call   5af <printf>
      printf(1, "%d.%d%d%d\t", table[i].elapsed_ticks/1000, table[i].elapsed_ticks%1000/100, table[i].elapsed_ticks%100/10, table[i].elapsed_ticks%10);
  ca:	8b 73 14             	mov    0x14(%ebx),%esi
  cd:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  d2:	f7 e6                	mul    %esi
  d4:	c1 ea 05             	shr    $0x5,%edx
  d7:	6b d2 64             	imul   $0x64,%edx,%edx
  da:	89 f0                	mov    %esi,%eax
  dc:	29 d0                	sub    %edx,%eax
  de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  e1:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  e6:	89 f0                	mov    %esi,%eax
  e8:	f7 e2                	mul    %edx
  ea:	89 55 e0             	mov    %edx,-0x20(%ebp)
  ed:	89 d1                	mov    %edx,%ecx
  ef:	c1 e9 06             	shr    $0x6,%ecx
  f2:	69 c9 e8 03 00 00    	imul   $0x3e8,%ecx,%ecx
  f8:	89 f0                	mov    %esi,%eax
  fa:	29 c8                	sub    %ecx,%eax
  fc:	89 c1                	mov    %eax,%ecx
  fe:	83 c4 08             	add    $0x8,%esp
 101:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
 106:	f7 e6                	mul    %esi
 108:	c1 ea 03             	shr    $0x3,%edx
 10b:	8d 04 92             	lea    (%edx,%edx,4),%eax
 10e:	01 c0                	add    %eax,%eax
 110:	29 c6                	sub    %eax,%esi
 112:	56                   	push   %esi
 113:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
 118:	f7 65 e4             	mull   -0x1c(%ebp)
 11b:	c1 ea 03             	shr    $0x3,%edx
 11e:	52                   	push   %edx
 11f:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
 124:	f7 e1                	mul    %ecx
 126:	c1 ea 05             	shr    $0x5,%edx
 129:	52                   	push   %edx
 12a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 12d:	c1 e8 06             	shr    $0x6,%eax
 130:	50                   	push   %eax
 131:	68 84 08 00 00       	push   $0x884
 136:	6a 01                	push   $0x1
 138:	e8 72 04 00 00       	call   5af <printf>
      printf(1, "0.0%d\t", table[i].CPU_total_ticks);
 13d:	83 c4 1c             	add    $0x1c,%esp
 140:	ff 73 18             	pushl  0x18(%ebx)
 143:	68 8f 08 00 00       	push   $0x88f
 148:	6a 01                	push   $0x1
 14a:	e8 60 04 00 00       	call   5af <printf>
      printf(1, "%s\t%d\n", table[i].state, table[i].size);
 14f:	8d 43 1c             	lea    0x1c(%ebx),%eax
 152:	ff 73 3c             	pushl  0x3c(%ebx)
 155:	50                   	push   %eax
 156:	68 96 08 00 00       	push   $0x896
 15b:	6a 01                	push   $0x1
 15d:	e8 4d 04 00 00       	call   5af <printf>
    for(i = 0; i < get; ++i)
 162:	83 c7 01             	add    $0x1,%edi
 165:	83 c4 20             	add    $0x20,%esp
 168:	3b 7d dc             	cmp    -0x24(%ebp),%edi
 16b:	0f 8c 20 ff ff ff    	jl     91 <main+0x91>
    printf(1, "\n");
 171:	83 ec 08             	sub    $0x8,%esp
 174:	68 9b 08 00 00       	push   $0x89b
 179:	6a 01                	push   $0x1
 17b:	e8 2f 04 00 00       	call   5af <printf>
 180:	83 c4 10             	add    $0x10,%esp
 183:	e9 c9 fe ff ff       	jmp    51 <main+0x51>

00000188 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 188:	f3 0f 1e fb          	endbr32 
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	56                   	push   %esi
 190:	53                   	push   %ebx
 191:	8b 75 08             	mov    0x8(%ebp),%esi
 194:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 197:	89 f0                	mov    %esi,%eax
 199:	89 d1                	mov    %edx,%ecx
 19b:	83 c2 01             	add    $0x1,%edx
 19e:	89 c3                	mov    %eax,%ebx
 1a0:	83 c0 01             	add    $0x1,%eax
 1a3:	0f b6 09             	movzbl (%ecx),%ecx
 1a6:	88 0b                	mov    %cl,(%ebx)
 1a8:	84 c9                	test   %cl,%cl
 1aa:	75 ed                	jne    199 <strcpy+0x11>
    ;
  return os;
}
 1ac:	89 f0                	mov    %esi,%eax
 1ae:	5b                   	pop    %ebx
 1af:	5e                   	pop    %esi
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    

000001b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b2:	f3 0f 1e fb          	endbr32 
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1bf:	0f b6 01             	movzbl (%ecx),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	74 0c                	je     1d2 <strcmp+0x20>
 1c6:	3a 02                	cmp    (%edx),%al
 1c8:	75 08                	jne    1d2 <strcmp+0x20>
    p++, q++;
 1ca:	83 c1 01             	add    $0x1,%ecx
 1cd:	83 c2 01             	add    $0x1,%edx
 1d0:	eb ed                	jmp    1bf <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 1d2:	0f b6 c0             	movzbl %al,%eax
 1d5:	0f b6 12             	movzbl (%edx),%edx
 1d8:	29 d0                	sub    %edx,%eax
}
 1da:	5d                   	pop    %ebp
 1db:	c3                   	ret    

000001dc <strlen>:

uint
strlen(char *s)
{
 1dc:	f3 0f 1e fb          	endbr32 
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1e6:	b8 00 00 00 00       	mov    $0x0,%eax
 1eb:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1ef:	74 05                	je     1f6 <strlen+0x1a>
 1f1:	83 c0 01             	add    $0x1,%eax
 1f4:	eb f5                	jmp    1eb <strlen+0xf>
    ;
  return n;
}
 1f6:	5d                   	pop    %ebp
 1f7:	c3                   	ret    

000001f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f8:	f3 0f 1e fb          	endbr32 
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	57                   	push   %edi
 200:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 203:	89 d7                	mov    %edx,%edi
 205:	8b 4d 10             	mov    0x10(%ebp),%ecx
 208:	8b 45 0c             	mov    0xc(%ebp),%eax
 20b:	fc                   	cld    
 20c:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 20e:	89 d0                	mov    %edx,%eax
 210:	5f                   	pop    %edi
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    

00000213 <strchr>:

char*
strchr(const char *s, char c)
{
 213:	f3 0f 1e fb          	endbr32 
 217:	55                   	push   %ebp
 218:	89 e5                	mov    %esp,%ebp
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 221:	0f b6 10             	movzbl (%eax),%edx
 224:	84 d2                	test   %dl,%dl
 226:	74 09                	je     231 <strchr+0x1e>
    if(*s == c)
 228:	38 ca                	cmp    %cl,%dl
 22a:	74 0a                	je     236 <strchr+0x23>
  for(; *s; s++)
 22c:	83 c0 01             	add    $0x1,%eax
 22f:	eb f0                	jmp    221 <strchr+0xe>
      return (char*)s;
  return 0;
 231:	b8 00 00 00 00       	mov    $0x0,%eax
}
 236:	5d                   	pop    %ebp
 237:	c3                   	ret    

00000238 <gets>:

char*
gets(char *buf, int max)
{
 238:	f3 0f 1e fb          	endbr32 
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	57                   	push   %edi
 240:	56                   	push   %esi
 241:	53                   	push   %ebx
 242:	83 ec 1c             	sub    $0x1c,%esp
 245:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 248:	bb 00 00 00 00       	mov    $0x0,%ebx
 24d:	89 de                	mov    %ebx,%esi
 24f:	83 c3 01             	add    $0x1,%ebx
 252:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 255:	7d 2e                	jge    285 <gets+0x4d>
    cc = read(0, &c, 1);
 257:	83 ec 04             	sub    $0x4,%esp
 25a:	6a 01                	push   $0x1
 25c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 25f:	50                   	push   %eax
 260:	6a 00                	push   $0x0
 262:	e8 cf 01 00 00       	call   436 <read>
    if(cc < 1)
 267:	83 c4 10             	add    $0x10,%esp
 26a:	85 c0                	test   %eax,%eax
 26c:	7e 17                	jle    285 <gets+0x4d>
      break;
    buf[i++] = c;
 26e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 272:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 275:	3c 0a                	cmp    $0xa,%al
 277:	0f 94 c2             	sete   %dl
 27a:	3c 0d                	cmp    $0xd,%al
 27c:	0f 94 c0             	sete   %al
 27f:	08 c2                	or     %al,%dl
 281:	74 ca                	je     24d <gets+0x15>
    buf[i++] = c;
 283:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 285:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 289:	89 f8                	mov    %edi,%eax
 28b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 28e:	5b                   	pop    %ebx
 28f:	5e                   	pop    %esi
 290:	5f                   	pop    %edi
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    

00000293 <stat>:

int
stat(char *n, struct stat *st)
{
 293:	f3 0f 1e fb          	endbr32 
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	56                   	push   %esi
 29b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29c:	83 ec 08             	sub    $0x8,%esp
 29f:	6a 00                	push   $0x0
 2a1:	ff 75 08             	pushl  0x8(%ebp)
 2a4:	e8 b5 01 00 00       	call   45e <open>
  if(fd < 0)
 2a9:	83 c4 10             	add    $0x10,%esp
 2ac:	85 c0                	test   %eax,%eax
 2ae:	78 24                	js     2d4 <stat+0x41>
 2b0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2b2:	83 ec 08             	sub    $0x8,%esp
 2b5:	ff 75 0c             	pushl  0xc(%ebp)
 2b8:	50                   	push   %eax
 2b9:	e8 b8 01 00 00       	call   476 <fstat>
 2be:	89 c6                	mov    %eax,%esi
  close(fd);
 2c0:	89 1c 24             	mov    %ebx,(%esp)
 2c3:	e8 7e 01 00 00       	call   446 <close>
  return r;
 2c8:	83 c4 10             	add    $0x10,%esp
}
 2cb:	89 f0                	mov    %esi,%eax
 2cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2d0:	5b                   	pop    %ebx
 2d1:	5e                   	pop    %esi
 2d2:	5d                   	pop    %ebp
 2d3:	c3                   	ret    
    return -1;
 2d4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2d9:	eb f0                	jmp    2cb <stat+0x38>

000002db <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 2db:	f3 0f 1e fb          	endbr32 
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	57                   	push   %edi
 2e3:	56                   	push   %esi
 2e4:	53                   	push   %ebx
 2e5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2e8:	0f b6 02             	movzbl (%edx),%eax
 2eb:	3c 20                	cmp    $0x20,%al
 2ed:	75 05                	jne    2f4 <atoi+0x19>
 2ef:	83 c2 01             	add    $0x1,%edx
 2f2:	eb f4                	jmp    2e8 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 2f4:	3c 2d                	cmp    $0x2d,%al
 2f6:	74 1d                	je     315 <atoi+0x3a>
 2f8:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2fd:	3c 2b                	cmp    $0x2b,%al
 2ff:	0f 94 c1             	sete   %cl
 302:	3c 2d                	cmp    $0x2d,%al
 304:	0f 94 c0             	sete   %al
 307:	08 c1                	or     %al,%cl
 309:	74 03                	je     30e <atoi+0x33>
    s++;
 30b:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 30e:	b8 00 00 00 00       	mov    $0x0,%eax
 313:	eb 17                	jmp    32c <atoi+0x51>
 315:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 31a:	eb e1                	jmp    2fd <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 31c:	8d 34 80             	lea    (%eax,%eax,4),%esi
 31f:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 322:	83 c2 01             	add    $0x1,%edx
 325:	0f be c9             	movsbl %cl,%ecx
 328:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 32c:	0f b6 0a             	movzbl (%edx),%ecx
 32f:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 332:	80 fb 09             	cmp    $0x9,%bl
 335:	76 e5                	jbe    31c <atoi+0x41>
  return sign*n;
 337:	0f af c7             	imul   %edi,%eax
}
 33a:	5b                   	pop    %ebx
 33b:	5e                   	pop    %esi
 33c:	5f                   	pop    %edi
 33d:	5d                   	pop    %ebp
 33e:	c3                   	ret    

0000033f <atoo>:

int
atoo(const char *s)
{
 33f:	f3 0f 1e fb          	endbr32 
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	57                   	push   %edi
 347:	56                   	push   %esi
 348:	53                   	push   %ebx
 349:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 34c:	0f b6 0a             	movzbl (%edx),%ecx
 34f:	80 f9 20             	cmp    $0x20,%cl
 352:	75 05                	jne    359 <atoo+0x1a>
 354:	83 c2 01             	add    $0x1,%edx
 357:	eb f3                	jmp    34c <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 359:	80 f9 2d             	cmp    $0x2d,%cl
 35c:	74 23                	je     381 <atoo+0x42>
 35e:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 363:	80 f9 2b             	cmp    $0x2b,%cl
 366:	0f 94 c0             	sete   %al
 369:	89 c6                	mov    %eax,%esi
 36b:	80 f9 2d             	cmp    $0x2d,%cl
 36e:	0f 94 c0             	sete   %al
 371:	89 f3                	mov    %esi,%ebx
 373:	08 c3                	or     %al,%bl
 375:	74 03                	je     37a <atoo+0x3b>
    s++;
 377:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 37a:	b8 00 00 00 00       	mov    $0x0,%eax
 37f:	eb 11                	jmp    392 <atoo+0x53>
 381:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 386:	eb db                	jmp    363 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 388:	83 c2 01             	add    $0x1,%edx
 38b:	0f be c9             	movsbl %cl,%ecx
 38e:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 392:	0f b6 0a             	movzbl (%edx),%ecx
 395:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 398:	80 fb 07             	cmp    $0x7,%bl
 39b:	76 eb                	jbe    388 <atoo+0x49>
  return sign*n;
 39d:	0f af c7             	imul   %edi,%eax
}
 3a0:	5b                   	pop    %ebx
 3a1:	5e                   	pop    %esi
 3a2:	5f                   	pop    %edi
 3a3:	5d                   	pop    %ebp
 3a4:	c3                   	ret    

000003a5 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 3a5:	f3 0f 1e fb          	endbr32 
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
 3ac:	53                   	push   %ebx
 3ad:	8b 55 08             	mov    0x8(%ebp),%edx
 3b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 3b3:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 3b6:	eb 09                	jmp    3c1 <strncmp+0x1c>
      n--, p++, q++;
 3b8:	83 e8 01             	sub    $0x1,%eax
 3bb:	83 c2 01             	add    $0x1,%edx
 3be:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 3c1:	85 c0                	test   %eax,%eax
 3c3:	74 0b                	je     3d0 <strncmp+0x2b>
 3c5:	0f b6 1a             	movzbl (%edx),%ebx
 3c8:	84 db                	test   %bl,%bl
 3ca:	74 04                	je     3d0 <strncmp+0x2b>
 3cc:	3a 19                	cmp    (%ecx),%bl
 3ce:	74 e8                	je     3b8 <strncmp+0x13>
    if(n == 0)
 3d0:	85 c0                	test   %eax,%eax
 3d2:	74 0b                	je     3df <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 3d4:	0f b6 02             	movzbl (%edx),%eax
 3d7:	0f b6 11             	movzbl (%ecx),%edx
 3da:	29 d0                	sub    %edx,%eax
}
 3dc:	5b                   	pop    %ebx
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    
      return 0;
 3df:	b8 00 00 00 00       	mov    $0x0,%eax
 3e4:	eb f6                	jmp    3dc <strncmp+0x37>

000003e6 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e6:	f3 0f 1e fb          	endbr32 
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
 3ed:	56                   	push   %esi
 3ee:	53                   	push   %ebx
 3ef:	8b 75 08             	mov    0x8(%ebp),%esi
 3f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 3f8:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 3fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
 3fd:	85 c0                	test   %eax,%eax
 3ff:	7e 0f                	jle    410 <memmove+0x2a>
    *dst++ = *src++;
 401:	0f b6 01             	movzbl (%ecx),%eax
 404:	88 02                	mov    %al,(%edx)
 406:	8d 49 01             	lea    0x1(%ecx),%ecx
 409:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 40c:	89 d8                	mov    %ebx,%eax
 40e:	eb ea                	jmp    3fa <memmove+0x14>
  return vdst;
}
 410:	89 f0                	mov    %esi,%eax
 412:	5b                   	pop    %ebx
 413:	5e                   	pop    %esi
 414:	5d                   	pop    %ebp
 415:	c3                   	ret    

00000416 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 416:	b8 01 00 00 00       	mov    $0x1,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <exit>:
SYSCALL(exit)
 41e:	b8 02 00 00 00       	mov    $0x2,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <wait>:
SYSCALL(wait)
 426:	b8 03 00 00 00       	mov    $0x3,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <pipe>:
SYSCALL(pipe)
 42e:	b8 04 00 00 00       	mov    $0x4,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <read>:
SYSCALL(read)
 436:	b8 05 00 00 00       	mov    $0x5,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <write>:
SYSCALL(write)
 43e:	b8 10 00 00 00       	mov    $0x10,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <close>:
SYSCALL(close)
 446:	b8 15 00 00 00       	mov    $0x15,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <kill>:
SYSCALL(kill)
 44e:	b8 06 00 00 00       	mov    $0x6,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <exec>:
SYSCALL(exec)
 456:	b8 07 00 00 00       	mov    $0x7,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <open>:
SYSCALL(open)
 45e:	b8 0f 00 00 00       	mov    $0xf,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <mknod>:
SYSCALL(mknod)
 466:	b8 11 00 00 00       	mov    $0x11,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <unlink>:
SYSCALL(unlink)
 46e:	b8 12 00 00 00       	mov    $0x12,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <fstat>:
SYSCALL(fstat)
 476:	b8 08 00 00 00       	mov    $0x8,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <link>:
SYSCALL(link)
 47e:	b8 13 00 00 00       	mov    $0x13,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <mkdir>:
SYSCALL(mkdir)
 486:	b8 14 00 00 00       	mov    $0x14,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <chdir>:
SYSCALL(chdir)
 48e:	b8 09 00 00 00       	mov    $0x9,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <dup>:
SYSCALL(dup)
 496:	b8 0a 00 00 00       	mov    $0xa,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <getpid>:
SYSCALL(getpid)
 49e:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <sbrk>:
SYSCALL(sbrk)
 4a6:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <sleep>:
SYSCALL(sleep)
 4ae:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <uptime>:
SYSCALL(uptime)
 4b6:	b8 0e 00 00 00       	mov    $0xe,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <halt>:
SYSCALL(halt)
 4be:	b8 16 00 00 00       	mov    $0x16,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <date>:
SYSCALL(date)
 4c6:	b8 17 00 00 00       	mov    $0x17,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <getuid>:
SYSCALL(getuid)
 4ce:	b8 18 00 00 00       	mov    $0x18,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <getgid>:
SYSCALL(getgid)
 4d6:	b8 19 00 00 00       	mov    $0x19,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <getppid>:
SYSCALL(getppid)
 4de:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <setuid>:
SYSCALL(setuid)
 4e6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <setgid>:
SYSCALL(setgid)
 4ee:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <getprocs>:
SYSCALL(getprocs)
 4f6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <setpriority>:
SYSCALL(setpriority)
 4fe:	b8 1e 00 00 00       	mov    $0x1e,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <getpriority>:
SYSCALL(getpriority)
 506:	b8 1f 00 00 00       	mov    $0x1f,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 50e:	55                   	push   %ebp
 50f:	89 e5                	mov    %esp,%ebp
 511:	83 ec 1c             	sub    $0x1c,%esp
 514:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 517:	6a 01                	push   $0x1
 519:	8d 55 f4             	lea    -0xc(%ebp),%edx
 51c:	52                   	push   %edx
 51d:	50                   	push   %eax
 51e:	e8 1b ff ff ff       	call   43e <write>
}
 523:	83 c4 10             	add    $0x10,%esp
 526:	c9                   	leave  
 527:	c3                   	ret    

00000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	57                   	push   %edi
 52c:	56                   	push   %esi
 52d:	53                   	push   %ebx
 52e:	83 ec 2c             	sub    $0x2c,%esp
 531:	89 45 d0             	mov    %eax,-0x30(%ebp)
 534:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 536:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 53a:	0f 95 c2             	setne  %dl
 53d:	89 f0                	mov    %esi,%eax
 53f:	c1 e8 1f             	shr    $0x1f,%eax
 542:	84 c2                	test   %al,%dl
 544:	74 42                	je     588 <printint+0x60>
    neg = 1;
    x = -xx;
 546:	f7 de                	neg    %esi
    neg = 1;
 548:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 54f:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 554:	89 f0                	mov    %esi,%eax
 556:	ba 00 00 00 00       	mov    $0x0,%edx
 55b:	f7 f1                	div    %ecx
 55d:	89 df                	mov    %ebx,%edi
 55f:	83 c3 01             	add    $0x1,%ebx
 562:	0f b6 92 e4 08 00 00 	movzbl 0x8e4(%edx),%edx
 569:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 56d:	89 f2                	mov    %esi,%edx
 56f:	89 c6                	mov    %eax,%esi
 571:	39 d1                	cmp    %edx,%ecx
 573:	76 df                	jbe    554 <printint+0x2c>
  if(neg)
 575:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 579:	74 2f                	je     5aa <printint+0x82>
    buf[i++] = '-';
 57b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 580:	8d 5f 02             	lea    0x2(%edi),%ebx
 583:	8b 75 d0             	mov    -0x30(%ebp),%esi
 586:	eb 15                	jmp    59d <printint+0x75>
  neg = 0;
 588:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 58f:	eb be                	jmp    54f <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 591:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 596:	89 f0                	mov    %esi,%eax
 598:	e8 71 ff ff ff       	call   50e <putc>
  while(--i >= 0)
 59d:	83 eb 01             	sub    $0x1,%ebx
 5a0:	79 ef                	jns    591 <printint+0x69>
}
 5a2:	83 c4 2c             	add    $0x2c,%esp
 5a5:	5b                   	pop    %ebx
 5a6:	5e                   	pop    %esi
 5a7:	5f                   	pop    %edi
 5a8:	5d                   	pop    %ebp
 5a9:	c3                   	ret    
 5aa:	8b 75 d0             	mov    -0x30(%ebp),%esi
 5ad:	eb ee                	jmp    59d <printint+0x75>

000005af <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5af:	f3 0f 1e fb          	endbr32 
 5b3:	55                   	push   %ebp
 5b4:	89 e5                	mov    %esp,%ebp
 5b6:	57                   	push   %edi
 5b7:	56                   	push   %esi
 5b8:	53                   	push   %ebx
 5b9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5bc:	8d 45 10             	lea    0x10(%ebp),%eax
 5bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5c2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5c7:	bb 00 00 00 00       	mov    $0x0,%ebx
 5cc:	eb 14                	jmp    5e2 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5ce:	89 fa                	mov    %edi,%edx
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	e8 36 ff ff ff       	call   50e <putc>
 5d8:	eb 05                	jmp    5df <printf+0x30>
      }
    } else if(state == '%'){
 5da:	83 fe 25             	cmp    $0x25,%esi
 5dd:	74 25                	je     604 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 5df:	83 c3 01             	add    $0x1,%ebx
 5e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e5:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 5e9:	84 c0                	test   %al,%al
 5eb:	0f 84 23 01 00 00    	je     714 <printf+0x165>
    c = fmt[i] & 0xff;
 5f1:	0f be f8             	movsbl %al,%edi
 5f4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5f7:	85 f6                	test   %esi,%esi
 5f9:	75 df                	jne    5da <printf+0x2b>
      if(c == '%'){
 5fb:	83 f8 25             	cmp    $0x25,%eax
 5fe:	75 ce                	jne    5ce <printf+0x1f>
        state = '%';
 600:	89 c6                	mov    %eax,%esi
 602:	eb db                	jmp    5df <printf+0x30>
      if(c == 'd'){
 604:	83 f8 64             	cmp    $0x64,%eax
 607:	74 49                	je     652 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 609:	83 f8 78             	cmp    $0x78,%eax
 60c:	0f 94 c1             	sete   %cl
 60f:	83 f8 70             	cmp    $0x70,%eax
 612:	0f 94 c2             	sete   %dl
 615:	08 d1                	or     %dl,%cl
 617:	75 63                	jne    67c <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 619:	83 f8 73             	cmp    $0x73,%eax
 61c:	0f 84 84 00 00 00    	je     6a6 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 622:	83 f8 63             	cmp    $0x63,%eax
 625:	0f 84 b7 00 00 00    	je     6e2 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 62b:	83 f8 25             	cmp    $0x25,%eax
 62e:	0f 84 cc 00 00 00    	je     700 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 634:	ba 25 00 00 00       	mov    $0x25,%edx
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	e8 cd fe ff ff       	call   50e <putc>
        putc(fd, c);
 641:	89 fa                	mov    %edi,%edx
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	e8 c3 fe ff ff       	call   50e <putc>
      }
      state = 0;
 64b:	be 00 00 00 00       	mov    $0x0,%esi
 650:	eb 8d                	jmp    5df <printf+0x30>
        printint(fd, *ap, 10, 1);
 652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 655:	8b 17                	mov    (%edi),%edx
 657:	83 ec 0c             	sub    $0xc,%esp
 65a:	6a 01                	push   $0x1
 65c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	e8 bf fe ff ff       	call   528 <printint>
        ap++;
 669:	83 c7 04             	add    $0x4,%edi
 66c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 66f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 672:	be 00 00 00 00       	mov    $0x0,%esi
 677:	e9 63 ff ff ff       	jmp    5df <printf+0x30>
        printint(fd, *ap, 16, 0);
 67c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 67f:	8b 17                	mov    (%edi),%edx
 681:	83 ec 0c             	sub    $0xc,%esp
 684:	6a 00                	push   $0x0
 686:	b9 10 00 00 00       	mov    $0x10,%ecx
 68b:	8b 45 08             	mov    0x8(%ebp),%eax
 68e:	e8 95 fe ff ff       	call   528 <printint>
        ap++;
 693:	83 c7 04             	add    $0x4,%edi
 696:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 699:	83 c4 10             	add    $0x10,%esp
      state = 0;
 69c:	be 00 00 00 00       	mov    $0x0,%esi
 6a1:	e9 39 ff ff ff       	jmp    5df <printf+0x30>
        s = (char*)*ap;
 6a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a9:	8b 30                	mov    (%eax),%esi
        ap++;
 6ab:	83 c0 04             	add    $0x4,%eax
 6ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 6b1:	85 f6                	test   %esi,%esi
 6b3:	75 28                	jne    6dd <printf+0x12e>
          s = "(null)";
 6b5:	be dc 08 00 00       	mov    $0x8dc,%esi
 6ba:	8b 7d 08             	mov    0x8(%ebp),%edi
 6bd:	eb 0d                	jmp    6cc <printf+0x11d>
          putc(fd, *s);
 6bf:	0f be d2             	movsbl %dl,%edx
 6c2:	89 f8                	mov    %edi,%eax
 6c4:	e8 45 fe ff ff       	call   50e <putc>
          s++;
 6c9:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 6cc:	0f b6 16             	movzbl (%esi),%edx
 6cf:	84 d2                	test   %dl,%dl
 6d1:	75 ec                	jne    6bf <printf+0x110>
      state = 0;
 6d3:	be 00 00 00 00       	mov    $0x0,%esi
 6d8:	e9 02 ff ff ff       	jmp    5df <printf+0x30>
 6dd:	8b 7d 08             	mov    0x8(%ebp),%edi
 6e0:	eb ea                	jmp    6cc <printf+0x11d>
        putc(fd, *ap);
 6e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6e5:	0f be 17             	movsbl (%edi),%edx
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	e8 1e fe ff ff       	call   50e <putc>
        ap++;
 6f0:	83 c7 04             	add    $0x4,%edi
 6f3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6f6:	be 00 00 00 00       	mov    $0x0,%esi
 6fb:	e9 df fe ff ff       	jmp    5df <printf+0x30>
        putc(fd, c);
 700:	89 fa                	mov    %edi,%edx
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	e8 04 fe ff ff       	call   50e <putc>
      state = 0;
 70a:	be 00 00 00 00       	mov    $0x0,%esi
 70f:	e9 cb fe ff ff       	jmp    5df <printf+0x30>
    }
  }
}
 714:	8d 65 f4             	lea    -0xc(%ebp),%esp
 717:	5b                   	pop    %ebx
 718:	5e                   	pop    %esi
 719:	5f                   	pop    %edi
 71a:	5d                   	pop    %ebp
 71b:	c3                   	ret    

0000071c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71c:	f3 0f 1e fb          	endbr32 
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 729:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	a1 ec 0b 00 00       	mov    0xbec,%eax
 731:	eb 02                	jmp    735 <free+0x19>
 733:	89 d0                	mov    %edx,%eax
 735:	39 c8                	cmp    %ecx,%eax
 737:	73 04                	jae    73d <free+0x21>
 739:	39 08                	cmp    %ecx,(%eax)
 73b:	77 12                	ja     74f <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73d:	8b 10                	mov    (%eax),%edx
 73f:	39 c2                	cmp    %eax,%edx
 741:	77 f0                	ja     733 <free+0x17>
 743:	39 c8                	cmp    %ecx,%eax
 745:	72 08                	jb     74f <free+0x33>
 747:	39 ca                	cmp    %ecx,%edx
 749:	77 04                	ja     74f <free+0x33>
 74b:	89 d0                	mov    %edx,%eax
 74d:	eb e6                	jmp    735 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 74f:	8b 73 fc             	mov    -0x4(%ebx),%esi
 752:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 755:	8b 10                	mov    (%eax),%edx
 757:	39 d7                	cmp    %edx,%edi
 759:	74 19                	je     774 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 75b:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 75e:	8b 50 04             	mov    0x4(%eax),%edx
 761:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 764:	39 ce                	cmp    %ecx,%esi
 766:	74 1b                	je     783 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 768:	89 08                	mov    %ecx,(%eax)
  freep = p;
 76a:	a3 ec 0b 00 00       	mov    %eax,0xbec
}
 76f:	5b                   	pop    %ebx
 770:	5e                   	pop    %esi
 771:	5f                   	pop    %edi
 772:	5d                   	pop    %ebp
 773:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 774:	03 72 04             	add    0x4(%edx),%esi
 777:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 77a:	8b 10                	mov    (%eax),%edx
 77c:	8b 12                	mov    (%edx),%edx
 77e:	89 53 f8             	mov    %edx,-0x8(%ebx)
 781:	eb db                	jmp    75e <free+0x42>
    p->s.size += bp->s.size;
 783:	03 53 fc             	add    -0x4(%ebx),%edx
 786:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 789:	8b 53 f8             	mov    -0x8(%ebx),%edx
 78c:	89 10                	mov    %edx,(%eax)
 78e:	eb da                	jmp    76a <free+0x4e>

00000790 <morecore>:

static Header*
morecore(uint nu)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	53                   	push   %ebx
 794:	83 ec 04             	sub    $0x4,%esp
 797:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 799:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 79e:	77 05                	ja     7a5 <morecore+0x15>
    nu = 4096;
 7a0:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 7a5:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7ac:	83 ec 0c             	sub    $0xc,%esp
 7af:	50                   	push   %eax
 7b0:	e8 f1 fc ff ff       	call   4a6 <sbrk>
  if(p == (char*)-1)
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	83 f8 ff             	cmp    $0xffffffff,%eax
 7bb:	74 1c                	je     7d9 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7bd:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7c0:	83 c0 08             	add    $0x8,%eax
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	50                   	push   %eax
 7c7:	e8 50 ff ff ff       	call   71c <free>
  return freep;
 7cc:	a1 ec 0b 00 00       	mov    0xbec,%eax
 7d1:	83 c4 10             	add    $0x10,%esp
}
 7d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7d7:	c9                   	leave  
 7d8:	c3                   	ret    
    return 0;
 7d9:	b8 00 00 00 00       	mov    $0x0,%eax
 7de:	eb f4                	jmp    7d4 <morecore+0x44>

000007e0 <malloc>:

void*
malloc(uint nbytes)
{
 7e0:	f3 0f 1e fb          	endbr32 
 7e4:	55                   	push   %ebp
 7e5:	89 e5                	mov    %esp,%ebp
 7e7:	53                   	push   %ebx
 7e8:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	8d 58 07             	lea    0x7(%eax),%ebx
 7f1:	c1 eb 03             	shr    $0x3,%ebx
 7f4:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 7f7:	8b 0d ec 0b 00 00    	mov    0xbec,%ecx
 7fd:	85 c9                	test   %ecx,%ecx
 7ff:	74 04                	je     805 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 801:	8b 01                	mov    (%ecx),%eax
 803:	eb 4b                	jmp    850 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 805:	c7 05 ec 0b 00 00 f0 	movl   $0xbf0,0xbec
 80c:	0b 00 00 
 80f:	c7 05 f0 0b 00 00 f0 	movl   $0xbf0,0xbf0
 816:	0b 00 00 
    base.s.size = 0;
 819:	c7 05 f4 0b 00 00 00 	movl   $0x0,0xbf4
 820:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 823:	b9 f0 0b 00 00       	mov    $0xbf0,%ecx
 828:	eb d7                	jmp    801 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 82a:	74 1a                	je     846 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 82c:	29 da                	sub    %ebx,%edx
 82e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 831:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 834:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 837:	89 0d ec 0b 00 00    	mov    %ecx,0xbec
      return (void*)(p + 1);
 83d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 840:	83 c4 04             	add    $0x4,%esp
 843:	5b                   	pop    %ebx
 844:	5d                   	pop    %ebp
 845:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	89 11                	mov    %edx,(%ecx)
 84a:	eb eb                	jmp    837 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	89 c1                	mov    %eax,%ecx
 84e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 850:	8b 50 04             	mov    0x4(%eax),%edx
 853:	39 da                	cmp    %ebx,%edx
 855:	73 d3                	jae    82a <malloc+0x4a>
    if(p == freep)
 857:	39 05 ec 0b 00 00    	cmp    %eax,0xbec
 85d:	75 ed                	jne    84c <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 85f:	89 d8                	mov    %ebx,%eax
 861:	e8 2a ff ff ff       	call   790 <morecore>
 866:	85 c0                	test   %eax,%eax
 868:	75 e2                	jne    84c <malloc+0x6c>
 86a:	eb d4                	jmp    840 <malloc+0x60>
