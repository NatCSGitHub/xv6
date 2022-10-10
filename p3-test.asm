
_p3-test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "param.h"
#include "pdx.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	8b 71 04             	mov    0x4(%ecx),%esi
  int rc, i = 0, childCount = 20;

  if (argc > 1) {
  1a:	83 39 01             	cmpl   $0x1,(%ecx)
  1d:	7e 2a                	jle    49 <main+0x49>
    childCount = atoi(argv[1]);
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	ff 76 04             	pushl  0x4(%esi)
  25:	e8 c4 01 00 00       	call   1ee <atoi>
  2a:	89 c3                	mov    %eax,%ebx
  }
  if (!childCount) {
  2c:	83 c4 10             	add    $0x10,%esp
  2f:	85 c0                	test   %eax,%eax
  31:	75 1b                	jne    4e <main+0x4e>
    printf(1, "No children to create, so %s is exiting.\n", argv[0]);
  33:	83 ec 04             	sub    $0x4,%esp
  36:	ff 36                	pushl  (%esi)
  38:	68 80 07 00 00       	push   $0x780
  3d:	6a 01                	push   $0x1
  3f:	e8 7e 04 00 00       	call   4c2 <printf>
    exit();
  44:	e8 e8 02 00 00       	call   331 <exit>
  int rc, i = 0, childCount = 20;
  49:	bb 14 00 00 00       	mov    $0x14,%ebx
  }

  printf(1, "Starting %d child processes that will run forever\n", childCount);
  4e:	83 ec 04             	sub    $0x4,%esp
  51:	53                   	push   %ebx
  52:	68 ac 07 00 00       	push   $0x7ac
  57:	6a 01                	push   $0x1
  59:	e8 64 04 00 00       	call   4c2 <printf>
  5e:	83 c4 10             	add    $0x10,%esp

  do {
    rc = fork();
  61:	e8 c3 02 00 00       	call   329 <fork>
    if (rc < 0) {
  66:	85 c0                	test   %eax,%eax
  68:	78 1b                	js     85 <main+0x85>
      printf(2, "Fork failed!\n");
      exit();
    }
    if (rc == 0) { // child process
  6a:	74 2d                	je     99 <main+0x99>
      while(1) i++;  // infinite
      exit();  // not reachable.
    }
    childCount--;
  } while(childCount);
  6c:	83 eb 01             	sub    $0x1,%ebx
  6f:	75 f0                	jne    61 <main+0x61>

  printf(1, "All child processes created\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 ed 07 00 00       	push   $0x7ed
  79:	6a 01                	push   $0x1
  7b:	e8 42 04 00 00       	call   4c2 <printf>
  80:	83 c4 10             	add    $0x10,%esp
  while(1) i++;  // loop forever and don't call wait. Good for zombie check
  83:	eb fe                	jmp    83 <main+0x83>
      printf(2, "Fork failed!\n");
  85:	83 ec 08             	sub    $0x8,%esp
  88:	68 df 07 00 00       	push   $0x7df
  8d:	6a 02                	push   $0x2
  8f:	e8 2e 04 00 00       	call   4c2 <printf>
      exit();
  94:	e8 98 02 00 00       	call   331 <exit>
      while(1) i++;  // infinite
  99:	eb fe                	jmp    99 <main+0x99>

0000009b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9b:	f3 0f 1e fb          	endbr32 
  9f:	55                   	push   %ebp
  a0:	89 e5                	mov    %esp,%ebp
  a2:	56                   	push   %esi
  a3:	53                   	push   %ebx
  a4:	8b 75 08             	mov    0x8(%ebp),%esi
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  aa:	89 f0                	mov    %esi,%eax
  ac:	89 d1                	mov    %edx,%ecx
  ae:	83 c2 01             	add    $0x1,%edx
  b1:	89 c3                	mov    %eax,%ebx
  b3:	83 c0 01             	add    $0x1,%eax
  b6:	0f b6 09             	movzbl (%ecx),%ecx
  b9:	88 0b                	mov    %cl,(%ebx)
  bb:	84 c9                	test   %cl,%cl
  bd:	75 ed                	jne    ac <strcpy+0x11>
    ;
  return os;
}
  bf:	89 f0                	mov    %esi,%eax
  c1:	5b                   	pop    %ebx
  c2:	5e                   	pop    %esi
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c5:	f3 0f 1e fb          	endbr32 
  c9:	55                   	push   %ebp
  ca:	89 e5                	mov    %esp,%ebp
  cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  d2:	0f b6 01             	movzbl (%ecx),%eax
  d5:	84 c0                	test   %al,%al
  d7:	74 0c                	je     e5 <strcmp+0x20>
  d9:	3a 02                	cmp    (%edx),%al
  db:	75 08                	jne    e5 <strcmp+0x20>
    p++, q++;
  dd:	83 c1 01             	add    $0x1,%ecx
  e0:	83 c2 01             	add    $0x1,%edx
  e3:	eb ed                	jmp    d2 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  e5:	0f b6 c0             	movzbl %al,%eax
  e8:	0f b6 12             	movzbl (%edx),%edx
  eb:	29 d0                	sub    %edx,%eax
}
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret    

000000ef <strlen>:

uint
strlen(char *s)
{
  ef:	f3 0f 1e fb          	endbr32 
  f3:	55                   	push   %ebp
  f4:	89 e5                	mov    %esp,%ebp
  f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  f9:	b8 00 00 00 00       	mov    $0x0,%eax
  fe:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 102:	74 05                	je     109 <strlen+0x1a>
 104:	83 c0 01             	add    $0x1,%eax
 107:	eb f5                	jmp    fe <strlen+0xf>
    ;
  return n;
}
 109:	5d                   	pop    %ebp
 10a:	c3                   	ret    

0000010b <memset>:

void*
memset(void *dst, int c, uint n)
{
 10b:	f3 0f 1e fb          	endbr32 
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 116:	89 d7                	mov    %edx,%edi
 118:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	fc                   	cld    
 11f:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 121:	89 d0                	mov    %edx,%eax
 123:	5f                   	pop    %edi
 124:	5d                   	pop    %ebp
 125:	c3                   	ret    

00000126 <strchr>:

char*
strchr(const char *s, char c)
{
 126:	f3 0f 1e fb          	endbr32 
 12a:	55                   	push   %ebp
 12b:	89 e5                	mov    %esp,%ebp
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 134:	0f b6 10             	movzbl (%eax),%edx
 137:	84 d2                	test   %dl,%dl
 139:	74 09                	je     144 <strchr+0x1e>
    if(*s == c)
 13b:	38 ca                	cmp    %cl,%dl
 13d:	74 0a                	je     149 <strchr+0x23>
  for(; *s; s++)
 13f:	83 c0 01             	add    $0x1,%eax
 142:	eb f0                	jmp    134 <strchr+0xe>
      return (char*)s;
  return 0;
 144:	b8 00 00 00 00       	mov    $0x0,%eax
}
 149:	5d                   	pop    %ebp
 14a:	c3                   	ret    

0000014b <gets>:

char*
gets(char *buf, int max)
{
 14b:	f3 0f 1e fb          	endbr32 
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
 152:	57                   	push   %edi
 153:	56                   	push   %esi
 154:	53                   	push   %ebx
 155:	83 ec 1c             	sub    $0x1c,%esp
 158:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15b:	bb 00 00 00 00       	mov    $0x0,%ebx
 160:	89 de                	mov    %ebx,%esi
 162:	83 c3 01             	add    $0x1,%ebx
 165:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 168:	7d 2e                	jge    198 <gets+0x4d>
    cc = read(0, &c, 1);
 16a:	83 ec 04             	sub    $0x4,%esp
 16d:	6a 01                	push   $0x1
 16f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 172:	50                   	push   %eax
 173:	6a 00                	push   $0x0
 175:	e8 cf 01 00 00       	call   349 <read>
    if(cc < 1)
 17a:	83 c4 10             	add    $0x10,%esp
 17d:	85 c0                	test   %eax,%eax
 17f:	7e 17                	jle    198 <gets+0x4d>
      break;
    buf[i++] = c;
 181:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 185:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 188:	3c 0a                	cmp    $0xa,%al
 18a:	0f 94 c2             	sete   %dl
 18d:	3c 0d                	cmp    $0xd,%al
 18f:	0f 94 c0             	sete   %al
 192:	08 c2                	or     %al,%dl
 194:	74 ca                	je     160 <gets+0x15>
    buf[i++] = c;
 196:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 198:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 19c:	89 f8                	mov    %edi,%eax
 19e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1a1:	5b                   	pop    %ebx
 1a2:	5e                   	pop    %esi
 1a3:	5f                   	pop    %edi
 1a4:	5d                   	pop    %ebp
 1a5:	c3                   	ret    

000001a6 <stat>:

int
stat(char *n, struct stat *st)
{
 1a6:	f3 0f 1e fb          	endbr32 
 1aa:	55                   	push   %ebp
 1ab:	89 e5                	mov    %esp,%ebp
 1ad:	56                   	push   %esi
 1ae:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1af:	83 ec 08             	sub    $0x8,%esp
 1b2:	6a 00                	push   $0x0
 1b4:	ff 75 08             	pushl  0x8(%ebp)
 1b7:	e8 b5 01 00 00       	call   371 <open>
  if(fd < 0)
 1bc:	83 c4 10             	add    $0x10,%esp
 1bf:	85 c0                	test   %eax,%eax
 1c1:	78 24                	js     1e7 <stat+0x41>
 1c3:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1c5:	83 ec 08             	sub    $0x8,%esp
 1c8:	ff 75 0c             	pushl  0xc(%ebp)
 1cb:	50                   	push   %eax
 1cc:	e8 b8 01 00 00       	call   389 <fstat>
 1d1:	89 c6                	mov    %eax,%esi
  close(fd);
 1d3:	89 1c 24             	mov    %ebx,(%esp)
 1d6:	e8 7e 01 00 00       	call   359 <close>
  return r;
 1db:	83 c4 10             	add    $0x10,%esp
}
 1de:	89 f0                	mov    %esi,%eax
 1e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1e3:	5b                   	pop    %ebx
 1e4:	5e                   	pop    %esi
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    
    return -1;
 1e7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1ec:	eb f0                	jmp    1de <stat+0x38>

000001ee <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1ee:	f3 0f 1e fb          	endbr32 
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	57                   	push   %edi
 1f6:	56                   	push   %esi
 1f7:	53                   	push   %ebx
 1f8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1fb:	0f b6 02             	movzbl (%edx),%eax
 1fe:	3c 20                	cmp    $0x20,%al
 200:	75 05                	jne    207 <atoi+0x19>
 202:	83 c2 01             	add    $0x1,%edx
 205:	eb f4                	jmp    1fb <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 207:	3c 2d                	cmp    $0x2d,%al
 209:	74 1d                	je     228 <atoi+0x3a>
 20b:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 210:	3c 2b                	cmp    $0x2b,%al
 212:	0f 94 c1             	sete   %cl
 215:	3c 2d                	cmp    $0x2d,%al
 217:	0f 94 c0             	sete   %al
 21a:	08 c1                	or     %al,%cl
 21c:	74 03                	je     221 <atoi+0x33>
    s++;
 21e:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 221:	b8 00 00 00 00       	mov    $0x0,%eax
 226:	eb 17                	jmp    23f <atoi+0x51>
 228:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 22d:	eb e1                	jmp    210 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 22f:	8d 34 80             	lea    (%eax,%eax,4),%esi
 232:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 235:	83 c2 01             	add    $0x1,%edx
 238:	0f be c9             	movsbl %cl,%ecx
 23b:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 23f:	0f b6 0a             	movzbl (%edx),%ecx
 242:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 245:	80 fb 09             	cmp    $0x9,%bl
 248:	76 e5                	jbe    22f <atoi+0x41>
  return sign*n;
 24a:	0f af c7             	imul   %edi,%eax
}
 24d:	5b                   	pop    %ebx
 24e:	5e                   	pop    %esi
 24f:	5f                   	pop    %edi
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <atoo>:

int
atoo(const char *s)
{
 252:	f3 0f 1e fb          	endbr32 
 256:	55                   	push   %ebp
 257:	89 e5                	mov    %esp,%ebp
 259:	57                   	push   %edi
 25a:	56                   	push   %esi
 25b:	53                   	push   %ebx
 25c:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 25f:	0f b6 0a             	movzbl (%edx),%ecx
 262:	80 f9 20             	cmp    $0x20,%cl
 265:	75 05                	jne    26c <atoo+0x1a>
 267:	83 c2 01             	add    $0x1,%edx
 26a:	eb f3                	jmp    25f <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 26c:	80 f9 2d             	cmp    $0x2d,%cl
 26f:	74 23                	je     294 <atoo+0x42>
 271:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 276:	80 f9 2b             	cmp    $0x2b,%cl
 279:	0f 94 c0             	sete   %al
 27c:	89 c6                	mov    %eax,%esi
 27e:	80 f9 2d             	cmp    $0x2d,%cl
 281:	0f 94 c0             	sete   %al
 284:	89 f3                	mov    %esi,%ebx
 286:	08 c3                	or     %al,%bl
 288:	74 03                	je     28d <atoo+0x3b>
    s++;
 28a:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 28d:	b8 00 00 00 00       	mov    $0x0,%eax
 292:	eb 11                	jmp    2a5 <atoo+0x53>
 294:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 299:	eb db                	jmp    276 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 29b:	83 c2 01             	add    $0x1,%edx
 29e:	0f be c9             	movsbl %cl,%ecx
 2a1:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2a5:	0f b6 0a             	movzbl (%edx),%ecx
 2a8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2ab:	80 fb 07             	cmp    $0x7,%bl
 2ae:	76 eb                	jbe    29b <atoo+0x49>
  return sign*n;
 2b0:	0f af c7             	imul   %edi,%eax
}
 2b3:	5b                   	pop    %ebx
 2b4:	5e                   	pop    %esi
 2b5:	5f                   	pop    %edi
 2b6:	5d                   	pop    %ebp
 2b7:	c3                   	ret    

000002b8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2b8:	f3 0f 1e fb          	endbr32 
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	53                   	push   %ebx
 2c0:	8b 55 08             	mov    0x8(%ebp),%edx
 2c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2c6:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2c9:	eb 09                	jmp    2d4 <strncmp+0x1c>
      n--, p++, q++;
 2cb:	83 e8 01             	sub    $0x1,%eax
 2ce:	83 c2 01             	add    $0x1,%edx
 2d1:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2d4:	85 c0                	test   %eax,%eax
 2d6:	74 0b                	je     2e3 <strncmp+0x2b>
 2d8:	0f b6 1a             	movzbl (%edx),%ebx
 2db:	84 db                	test   %bl,%bl
 2dd:	74 04                	je     2e3 <strncmp+0x2b>
 2df:	3a 19                	cmp    (%ecx),%bl
 2e1:	74 e8                	je     2cb <strncmp+0x13>
    if(n == 0)
 2e3:	85 c0                	test   %eax,%eax
 2e5:	74 0b                	je     2f2 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2e7:	0f b6 02             	movzbl (%edx),%eax
 2ea:	0f b6 11             	movzbl (%ecx),%edx
 2ed:	29 d0                	sub    %edx,%eax
}
 2ef:	5b                   	pop    %ebx
 2f0:	5d                   	pop    %ebp
 2f1:	c3                   	ret    
      return 0;
 2f2:	b8 00 00 00 00       	mov    $0x0,%eax
 2f7:	eb f6                	jmp    2ef <strncmp+0x37>

000002f9 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f9:	f3 0f 1e fb          	endbr32 
 2fd:	55                   	push   %ebp
 2fe:	89 e5                	mov    %esp,%ebp
 300:	56                   	push   %esi
 301:	53                   	push   %ebx
 302:	8b 75 08             	mov    0x8(%ebp),%esi
 305:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 308:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 30b:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 30d:	8d 58 ff             	lea    -0x1(%eax),%ebx
 310:	85 c0                	test   %eax,%eax
 312:	7e 0f                	jle    323 <memmove+0x2a>
    *dst++ = *src++;
 314:	0f b6 01             	movzbl (%ecx),%eax
 317:	88 02                	mov    %al,(%edx)
 319:	8d 49 01             	lea    0x1(%ecx),%ecx
 31c:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 31f:	89 d8                	mov    %ebx,%eax
 321:	eb ea                	jmp    30d <memmove+0x14>
  return vdst;
}
 323:	89 f0                	mov    %esi,%eax
 325:	5b                   	pop    %ebx
 326:	5e                   	pop    %esi
 327:	5d                   	pop    %ebp
 328:	c3                   	ret    

00000329 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 329:	b8 01 00 00 00       	mov    $0x1,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <exit>:
SYSCALL(exit)
 331:	b8 02 00 00 00       	mov    $0x2,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <wait>:
SYSCALL(wait)
 339:	b8 03 00 00 00       	mov    $0x3,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <pipe>:
SYSCALL(pipe)
 341:	b8 04 00 00 00       	mov    $0x4,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <read>:
SYSCALL(read)
 349:	b8 05 00 00 00       	mov    $0x5,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <write>:
SYSCALL(write)
 351:	b8 10 00 00 00       	mov    $0x10,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <close>:
SYSCALL(close)
 359:	b8 15 00 00 00       	mov    $0x15,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <kill>:
SYSCALL(kill)
 361:	b8 06 00 00 00       	mov    $0x6,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <exec>:
SYSCALL(exec)
 369:	b8 07 00 00 00       	mov    $0x7,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <open>:
SYSCALL(open)
 371:	b8 0f 00 00 00       	mov    $0xf,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <mknod>:
SYSCALL(mknod)
 379:	b8 11 00 00 00       	mov    $0x11,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <unlink>:
SYSCALL(unlink)
 381:	b8 12 00 00 00       	mov    $0x12,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <fstat>:
SYSCALL(fstat)
 389:	b8 08 00 00 00       	mov    $0x8,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <link>:
SYSCALL(link)
 391:	b8 13 00 00 00       	mov    $0x13,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <mkdir>:
SYSCALL(mkdir)
 399:	b8 14 00 00 00       	mov    $0x14,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <chdir>:
SYSCALL(chdir)
 3a1:	b8 09 00 00 00       	mov    $0x9,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <dup>:
SYSCALL(dup)
 3a9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <getpid>:
SYSCALL(getpid)
 3b1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <sbrk>:
SYSCALL(sbrk)
 3b9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <sleep>:
SYSCALL(sleep)
 3c1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <uptime>:
SYSCALL(uptime)
 3c9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <halt>:
SYSCALL(halt)
 3d1:	b8 16 00 00 00       	mov    $0x16,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <date>:
SYSCALL(date)
 3d9:	b8 17 00 00 00       	mov    $0x17,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <getuid>:
SYSCALL(getuid)
 3e1:	b8 18 00 00 00       	mov    $0x18,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <getgid>:
SYSCALL(getgid)
 3e9:	b8 19 00 00 00       	mov    $0x19,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <getppid>:
SYSCALL(getppid)
 3f1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <setuid>:
SYSCALL(setuid)
 3f9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <setgid>:
SYSCALL(setgid)
 401:	b8 1c 00 00 00       	mov    $0x1c,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <getprocs>:
SYSCALL(getprocs)
 409:	b8 1d 00 00 00       	mov    $0x1d,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <setpriority>:
SYSCALL(setpriority)
 411:	b8 1e 00 00 00       	mov    $0x1e,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <getpriority>:
SYSCALL(getpriority)
 419:	b8 1f 00 00 00       	mov    $0x1f,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp
 424:	83 ec 1c             	sub    $0x1c,%esp
 427:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 42a:	6a 01                	push   $0x1
 42c:	8d 55 f4             	lea    -0xc(%ebp),%edx
 42f:	52                   	push   %edx
 430:	50                   	push   %eax
 431:	e8 1b ff ff ff       	call   351 <write>
}
 436:	83 c4 10             	add    $0x10,%esp
 439:	c9                   	leave  
 43a:	c3                   	ret    

0000043b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43b:	55                   	push   %ebp
 43c:	89 e5                	mov    %esp,%ebp
 43e:	57                   	push   %edi
 43f:	56                   	push   %esi
 440:	53                   	push   %ebx
 441:	83 ec 2c             	sub    $0x2c,%esp
 444:	89 45 d0             	mov    %eax,-0x30(%ebp)
 447:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 449:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 44d:	0f 95 c2             	setne  %dl
 450:	89 f0                	mov    %esi,%eax
 452:	c1 e8 1f             	shr    $0x1f,%eax
 455:	84 c2                	test   %al,%dl
 457:	74 42                	je     49b <printint+0x60>
    neg = 1;
    x = -xx;
 459:	f7 de                	neg    %esi
    neg = 1;
 45b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 462:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 467:	89 f0                	mov    %esi,%eax
 469:	ba 00 00 00 00       	mov    $0x0,%edx
 46e:	f7 f1                	div    %ecx
 470:	89 df                	mov    %ebx,%edi
 472:	83 c3 01             	add    $0x1,%ebx
 475:	0f b6 92 14 08 00 00 	movzbl 0x814(%edx),%edx
 47c:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 480:	89 f2                	mov    %esi,%edx
 482:	89 c6                	mov    %eax,%esi
 484:	39 d1                	cmp    %edx,%ecx
 486:	76 df                	jbe    467 <printint+0x2c>
  if(neg)
 488:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 48c:	74 2f                	je     4bd <printint+0x82>
    buf[i++] = '-';
 48e:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 493:	8d 5f 02             	lea    0x2(%edi),%ebx
 496:	8b 75 d0             	mov    -0x30(%ebp),%esi
 499:	eb 15                	jmp    4b0 <printint+0x75>
  neg = 0;
 49b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 4a2:	eb be                	jmp    462 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 4a4:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4a9:	89 f0                	mov    %esi,%eax
 4ab:	e8 71 ff ff ff       	call   421 <putc>
  while(--i >= 0)
 4b0:	83 eb 01             	sub    $0x1,%ebx
 4b3:	79 ef                	jns    4a4 <printint+0x69>
}
 4b5:	83 c4 2c             	add    $0x2c,%esp
 4b8:	5b                   	pop    %ebx
 4b9:	5e                   	pop    %esi
 4ba:	5f                   	pop    %edi
 4bb:	5d                   	pop    %ebp
 4bc:	c3                   	ret    
 4bd:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4c0:	eb ee                	jmp    4b0 <printint+0x75>

000004c2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c2:	f3 0f 1e fb          	endbr32 
 4c6:	55                   	push   %ebp
 4c7:	89 e5                	mov    %esp,%ebp
 4c9:	57                   	push   %edi
 4ca:	56                   	push   %esi
 4cb:	53                   	push   %ebx
 4cc:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4cf:	8d 45 10             	lea    0x10(%ebp),%eax
 4d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4d5:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4da:	bb 00 00 00 00       	mov    $0x0,%ebx
 4df:	eb 14                	jmp    4f5 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4e1:	89 fa                	mov    %edi,%edx
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	e8 36 ff ff ff       	call   421 <putc>
 4eb:	eb 05                	jmp    4f2 <printf+0x30>
      }
    } else if(state == '%'){
 4ed:	83 fe 25             	cmp    $0x25,%esi
 4f0:	74 25                	je     517 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4f2:	83 c3 01             	add    $0x1,%ebx
 4f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f8:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4fc:	84 c0                	test   %al,%al
 4fe:	0f 84 23 01 00 00    	je     627 <printf+0x165>
    c = fmt[i] & 0xff;
 504:	0f be f8             	movsbl %al,%edi
 507:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 50a:	85 f6                	test   %esi,%esi
 50c:	75 df                	jne    4ed <printf+0x2b>
      if(c == '%'){
 50e:	83 f8 25             	cmp    $0x25,%eax
 511:	75 ce                	jne    4e1 <printf+0x1f>
        state = '%';
 513:	89 c6                	mov    %eax,%esi
 515:	eb db                	jmp    4f2 <printf+0x30>
      if(c == 'd'){
 517:	83 f8 64             	cmp    $0x64,%eax
 51a:	74 49                	je     565 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 51c:	83 f8 78             	cmp    $0x78,%eax
 51f:	0f 94 c1             	sete   %cl
 522:	83 f8 70             	cmp    $0x70,%eax
 525:	0f 94 c2             	sete   %dl
 528:	08 d1                	or     %dl,%cl
 52a:	75 63                	jne    58f <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 52c:	83 f8 73             	cmp    $0x73,%eax
 52f:	0f 84 84 00 00 00    	je     5b9 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 535:	83 f8 63             	cmp    $0x63,%eax
 538:	0f 84 b7 00 00 00    	je     5f5 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 53e:	83 f8 25             	cmp    $0x25,%eax
 541:	0f 84 cc 00 00 00    	je     613 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 547:	ba 25 00 00 00       	mov    $0x25,%edx
 54c:	8b 45 08             	mov    0x8(%ebp),%eax
 54f:	e8 cd fe ff ff       	call   421 <putc>
        putc(fd, c);
 554:	89 fa                	mov    %edi,%edx
 556:	8b 45 08             	mov    0x8(%ebp),%eax
 559:	e8 c3 fe ff ff       	call   421 <putc>
      }
      state = 0;
 55e:	be 00 00 00 00       	mov    $0x0,%esi
 563:	eb 8d                	jmp    4f2 <printf+0x30>
        printint(fd, *ap, 10, 1);
 565:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 568:	8b 17                	mov    (%edi),%edx
 56a:	83 ec 0c             	sub    $0xc,%esp
 56d:	6a 01                	push   $0x1
 56f:	b9 0a 00 00 00       	mov    $0xa,%ecx
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	e8 bf fe ff ff       	call   43b <printint>
        ap++;
 57c:	83 c7 04             	add    $0x4,%edi
 57f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 582:	83 c4 10             	add    $0x10,%esp
      state = 0;
 585:	be 00 00 00 00       	mov    $0x0,%esi
 58a:	e9 63 ff ff ff       	jmp    4f2 <printf+0x30>
        printint(fd, *ap, 16, 0);
 58f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 592:	8b 17                	mov    (%edi),%edx
 594:	83 ec 0c             	sub    $0xc,%esp
 597:	6a 00                	push   $0x0
 599:	b9 10 00 00 00       	mov    $0x10,%ecx
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	e8 95 fe ff ff       	call   43b <printint>
        ap++;
 5a6:	83 c7 04             	add    $0x4,%edi
 5a9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5ac:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5af:	be 00 00 00 00       	mov    $0x0,%esi
 5b4:	e9 39 ff ff ff       	jmp    4f2 <printf+0x30>
        s = (char*)*ap;
 5b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bc:	8b 30                	mov    (%eax),%esi
        ap++;
 5be:	83 c0 04             	add    $0x4,%eax
 5c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5c4:	85 f6                	test   %esi,%esi
 5c6:	75 28                	jne    5f0 <printf+0x12e>
          s = "(null)";
 5c8:	be 0a 08 00 00       	mov    $0x80a,%esi
 5cd:	8b 7d 08             	mov    0x8(%ebp),%edi
 5d0:	eb 0d                	jmp    5df <printf+0x11d>
          putc(fd, *s);
 5d2:	0f be d2             	movsbl %dl,%edx
 5d5:	89 f8                	mov    %edi,%eax
 5d7:	e8 45 fe ff ff       	call   421 <putc>
          s++;
 5dc:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5df:	0f b6 16             	movzbl (%esi),%edx
 5e2:	84 d2                	test   %dl,%dl
 5e4:	75 ec                	jne    5d2 <printf+0x110>
      state = 0;
 5e6:	be 00 00 00 00       	mov    $0x0,%esi
 5eb:	e9 02 ff ff ff       	jmp    4f2 <printf+0x30>
 5f0:	8b 7d 08             	mov    0x8(%ebp),%edi
 5f3:	eb ea                	jmp    5df <printf+0x11d>
        putc(fd, *ap);
 5f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5f8:	0f be 17             	movsbl (%edi),%edx
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	e8 1e fe ff ff       	call   421 <putc>
        ap++;
 603:	83 c7 04             	add    $0x4,%edi
 606:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 609:	be 00 00 00 00       	mov    $0x0,%esi
 60e:	e9 df fe ff ff       	jmp    4f2 <printf+0x30>
        putc(fd, c);
 613:	89 fa                	mov    %edi,%edx
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	e8 04 fe ff ff       	call   421 <putc>
      state = 0;
 61d:	be 00 00 00 00       	mov    $0x0,%esi
 622:	e9 cb fe ff ff       	jmp    4f2 <printf+0x30>
    }
  }
}
 627:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62a:	5b                   	pop    %ebx
 62b:	5e                   	pop    %esi
 62c:	5f                   	pop    %edi
 62d:	5d                   	pop    %ebp
 62e:	c3                   	ret    

0000062f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62f:	f3 0f 1e fb          	endbr32 
 633:	55                   	push   %ebp
 634:	89 e5                	mov    %esp,%ebp
 636:	57                   	push   %edi
 637:	56                   	push   %esi
 638:	53                   	push   %ebx
 639:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63c:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63f:	a1 18 0b 00 00       	mov    0xb18,%eax
 644:	eb 02                	jmp    648 <free+0x19>
 646:	89 d0                	mov    %edx,%eax
 648:	39 c8                	cmp    %ecx,%eax
 64a:	73 04                	jae    650 <free+0x21>
 64c:	39 08                	cmp    %ecx,(%eax)
 64e:	77 12                	ja     662 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	8b 10                	mov    (%eax),%edx
 652:	39 c2                	cmp    %eax,%edx
 654:	77 f0                	ja     646 <free+0x17>
 656:	39 c8                	cmp    %ecx,%eax
 658:	72 08                	jb     662 <free+0x33>
 65a:	39 ca                	cmp    %ecx,%edx
 65c:	77 04                	ja     662 <free+0x33>
 65e:	89 d0                	mov    %edx,%eax
 660:	eb e6                	jmp    648 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 662:	8b 73 fc             	mov    -0x4(%ebx),%esi
 665:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 668:	8b 10                	mov    (%eax),%edx
 66a:	39 d7                	cmp    %edx,%edi
 66c:	74 19                	je     687 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 66e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 677:	39 ce                	cmp    %ecx,%esi
 679:	74 1b                	je     696 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 67b:	89 08                	mov    %ecx,(%eax)
  freep = p;
 67d:	a3 18 0b 00 00       	mov    %eax,0xb18
}
 682:	5b                   	pop    %ebx
 683:	5e                   	pop    %esi
 684:	5f                   	pop    %edi
 685:	5d                   	pop    %ebp
 686:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 687:	03 72 04             	add    0x4(%edx),%esi
 68a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 68d:	8b 10                	mov    (%eax),%edx
 68f:	8b 12                	mov    (%edx),%edx
 691:	89 53 f8             	mov    %edx,-0x8(%ebx)
 694:	eb db                	jmp    671 <free+0x42>
    p->s.size += bp->s.size;
 696:	03 53 fc             	add    -0x4(%ebx),%edx
 699:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 69c:	8b 53 f8             	mov    -0x8(%ebx),%edx
 69f:	89 10                	mov    %edx,(%eax)
 6a1:	eb da                	jmp    67d <free+0x4e>

000006a3 <morecore>:

static Header*
morecore(uint nu)
{
 6a3:	55                   	push   %ebp
 6a4:	89 e5                	mov    %esp,%ebp
 6a6:	53                   	push   %ebx
 6a7:	83 ec 04             	sub    $0x4,%esp
 6aa:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6ac:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6b1:	77 05                	ja     6b8 <morecore+0x15>
    nu = 4096;
 6b3:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6b8:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6bf:	83 ec 0c             	sub    $0xc,%esp
 6c2:	50                   	push   %eax
 6c3:	e8 f1 fc ff ff       	call   3b9 <sbrk>
  if(p == (char*)-1)
 6c8:	83 c4 10             	add    $0x10,%esp
 6cb:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ce:	74 1c                	je     6ec <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6d0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6d3:	83 c0 08             	add    $0x8,%eax
 6d6:	83 ec 0c             	sub    $0xc,%esp
 6d9:	50                   	push   %eax
 6da:	e8 50 ff ff ff       	call   62f <free>
  return freep;
 6df:	a1 18 0b 00 00       	mov    0xb18,%eax
 6e4:	83 c4 10             	add    $0x10,%esp
}
 6e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6ea:	c9                   	leave  
 6eb:	c3                   	ret    
    return 0;
 6ec:	b8 00 00 00 00       	mov    $0x0,%eax
 6f1:	eb f4                	jmp    6e7 <morecore+0x44>

000006f3 <malloc>:

void*
malloc(uint nbytes)
{
 6f3:	f3 0f 1e fb          	endbr32 
 6f7:	55                   	push   %ebp
 6f8:	89 e5                	mov    %esp,%ebp
 6fa:	53                   	push   %ebx
 6fb:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6fe:	8b 45 08             	mov    0x8(%ebp),%eax
 701:	8d 58 07             	lea    0x7(%eax),%ebx
 704:	c1 eb 03             	shr    $0x3,%ebx
 707:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 70a:	8b 0d 18 0b 00 00    	mov    0xb18,%ecx
 710:	85 c9                	test   %ecx,%ecx
 712:	74 04                	je     718 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 714:	8b 01                	mov    (%ecx),%eax
 716:	eb 4b                	jmp    763 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 718:	c7 05 18 0b 00 00 1c 	movl   $0xb1c,0xb18
 71f:	0b 00 00 
 722:	c7 05 1c 0b 00 00 1c 	movl   $0xb1c,0xb1c
 729:	0b 00 00 
    base.s.size = 0;
 72c:	c7 05 20 0b 00 00 00 	movl   $0x0,0xb20
 733:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 736:	b9 1c 0b 00 00       	mov    $0xb1c,%ecx
 73b:	eb d7                	jmp    714 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 73d:	74 1a                	je     759 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 73f:	29 da                	sub    %ebx,%edx
 741:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 744:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 747:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 74a:	89 0d 18 0b 00 00    	mov    %ecx,0xb18
      return (void*)(p + 1);
 750:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 753:	83 c4 04             	add    $0x4,%esp
 756:	5b                   	pop    %ebx
 757:	5d                   	pop    %ebp
 758:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 759:	8b 10                	mov    (%eax),%edx
 75b:	89 11                	mov    %edx,(%ecx)
 75d:	eb eb                	jmp    74a <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75f:	89 c1                	mov    %eax,%ecx
 761:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 763:	8b 50 04             	mov    0x4(%eax),%edx
 766:	39 da                	cmp    %ebx,%edx
 768:	73 d3                	jae    73d <malloc+0x4a>
    if(p == freep)
 76a:	39 05 18 0b 00 00    	cmp    %eax,0xb18
 770:	75 ed                	jne    75f <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 772:	89 d8                	mov    %ebx,%eax
 774:	e8 2a ff ff ff       	call   6a3 <morecore>
 779:	85 c0                	test   %eax,%eax
 77b:	75 e2                	jne    75f <malloc+0x6c>
 77d:	eb d4                	jmp    753 <malloc+0x60>
