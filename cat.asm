
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   c:	83 ec 04             	sub    $0x4,%esp
   f:	68 00 02 00 00       	push   $0x200
  14:	68 80 0b 00 00       	push   $0xb80
  19:	56                   	push   %esi
  1a:	e8 8f 03 00 00       	call   3ae <read>
  1f:	89 c3                	mov    %eax,%ebx
  21:	83 c4 10             	add    $0x10,%esp
  24:	85 c0                	test   %eax,%eax
  26:	7e 2b                	jle    53 <cat+0x53>
    if (write(1, buf, n) != n) {
  28:	83 ec 04             	sub    $0x4,%esp
  2b:	53                   	push   %ebx
  2c:	68 80 0b 00 00       	push   $0xb80
  31:	6a 01                	push   $0x1
  33:	e8 7e 03 00 00       	call   3b6 <write>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 d8                	cmp    %ebx,%eax
  3d:	74 cd                	je     c <cat+0xc>
      printf(1, "cat: write error\n");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 e4 07 00 00       	push   $0x7e4
  47:	6a 01                	push   $0x1
  49:	e8 d9 04 00 00       	call   527 <printf>
      exit();
  4e:	e8 43 03 00 00       	call   396 <exit>
    }
  }
  if(n < 0){
  53:	78 07                	js     5c <cat+0x5c>
    printf(1, "cat: read error\n");
    exit();
  }
}
  55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  58:	5b                   	pop    %ebx
  59:	5e                   	pop    %esi
  5a:	5d                   	pop    %ebp
  5b:	c3                   	ret    
    printf(1, "cat: read error\n");
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 f6 07 00 00       	push   $0x7f6
  64:	6a 01                	push   $0x1
  66:	e8 bc 04 00 00       	call   527 <printf>
    exit();
  6b:	e8 26 03 00 00       	call   396 <exit>

00000070 <main>:

int
main(int argc, char *argv[])
{
  70:	f3 0f 1e fb          	endbr32 
  74:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  78:	83 e4 f0             	and    $0xfffffff0,%esp
  7b:	ff 71 fc             	pushl  -0x4(%ecx)
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	57                   	push   %edi
  82:	56                   	push   %esi
  83:	53                   	push   %ebx
  84:	51                   	push   %ecx
  85:	83 ec 18             	sub    $0x18,%esp
  88:	8b 01                	mov    (%ecx),%eax
  8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8d:	8b 51 04             	mov    0x4(%ecx),%edx
  90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  93:	83 f8 01             	cmp    $0x1,%eax
  96:	7e 3e                	jle    d6 <main+0x66>
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  98:	be 01 00 00 00       	mov    $0x1,%esi
  9d:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  a0:	7d 59                	jge    fb <main+0x8b>
    if((fd = open(argv[i], 0)) < 0){
  a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a5:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	6a 00                	push   $0x0
  ad:	ff 37                	pushl  (%edi)
  af:	e8 22 03 00 00       	call   3d6 <open>
  b4:	89 c3                	mov    %eax,%ebx
  b6:	83 c4 10             	add    $0x10,%esp
  b9:	85 c0                	test   %eax,%eax
  bb:	78 28                	js     e5 <main+0x75>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  bd:	83 ec 0c             	sub    $0xc,%esp
  c0:	50                   	push   %eax
  c1:	e8 3a ff ff ff       	call   0 <cat>
    close(fd);
  c6:	89 1c 24             	mov    %ebx,(%esp)
  c9:	e8 f0 02 00 00       	call   3be <close>
  for(i = 1; i < argc; i++){
  ce:	83 c6 01             	add    $0x1,%esi
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	eb c7                	jmp    9d <main+0x2d>
    cat(0);
  d6:	83 ec 0c             	sub    $0xc,%esp
  d9:	6a 00                	push   $0x0
  db:	e8 20 ff ff ff       	call   0 <cat>
    exit();
  e0:	e8 b1 02 00 00       	call   396 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  e5:	83 ec 04             	sub    $0x4,%esp
  e8:	ff 37                	pushl  (%edi)
  ea:	68 07 08 00 00       	push   $0x807
  ef:	6a 01                	push   $0x1
  f1:	e8 31 04 00 00       	call   527 <printf>
      exit();
  f6:	e8 9b 02 00 00       	call   396 <exit>
  }
  exit();
  fb:	e8 96 02 00 00       	call   396 <exit>

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	56                   	push   %esi
 108:	53                   	push   %ebx
 109:	8b 75 08             	mov    0x8(%ebp),%esi
 10c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10f:	89 f0                	mov    %esi,%eax
 111:	89 d1                	mov    %edx,%ecx
 113:	83 c2 01             	add    $0x1,%edx
 116:	89 c3                	mov    %eax,%ebx
 118:	83 c0 01             	add    $0x1,%eax
 11b:	0f b6 09             	movzbl (%ecx),%ecx
 11e:	88 0b                	mov    %cl,(%ebx)
 120:	84 c9                	test   %cl,%cl
 122:	75 ed                	jne    111 <strcpy+0x11>
    ;
  return os;
}
 124:	89 f0                	mov    %esi,%eax
 126:	5b                   	pop    %ebx
 127:	5e                   	pop    %esi
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    

0000012a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12a:	f3 0f 1e fb          	endbr32 
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	8b 4d 08             	mov    0x8(%ebp),%ecx
 134:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 137:	0f b6 01             	movzbl (%ecx),%eax
 13a:	84 c0                	test   %al,%al
 13c:	74 0c                	je     14a <strcmp+0x20>
 13e:	3a 02                	cmp    (%edx),%al
 140:	75 08                	jne    14a <strcmp+0x20>
    p++, q++;
 142:	83 c1 01             	add    $0x1,%ecx
 145:	83 c2 01             	add    $0x1,%edx
 148:	eb ed                	jmp    137 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 14a:	0f b6 c0             	movzbl %al,%eax
 14d:	0f b6 12             	movzbl (%edx),%edx
 150:	29 d0                	sub    %edx,%eax
}
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    

00000154 <strlen>:

uint
strlen(char *s)
{
 154:	f3 0f 1e fb          	endbr32 
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 15e:	b8 00 00 00 00       	mov    $0x0,%eax
 163:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 167:	74 05                	je     16e <strlen+0x1a>
 169:	83 c0 01             	add    $0x1,%eax
 16c:	eb f5                	jmp    163 <strlen+0xf>
    ;
  return n;
}
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	f3 0f 1e fb          	endbr32 
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	57                   	push   %edi
 178:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 17b:	89 d7                	mov    %edx,%edi
 17d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 180:	8b 45 0c             	mov    0xc(%ebp),%eax
 183:	fc                   	cld    
 184:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 186:	89 d0                	mov    %edx,%eax
 188:	5f                   	pop    %edi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    

0000018b <strchr>:

char*
strchr(const char *s, char c)
{
 18b:	f3 0f 1e fb          	endbr32 
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	8b 45 08             	mov    0x8(%ebp),%eax
 195:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 199:	0f b6 10             	movzbl (%eax),%edx
 19c:	84 d2                	test   %dl,%dl
 19e:	74 09                	je     1a9 <strchr+0x1e>
    if(*s == c)
 1a0:	38 ca                	cmp    %cl,%dl
 1a2:	74 0a                	je     1ae <strchr+0x23>
  for(; *s; s++)
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	eb f0                	jmp    199 <strchr+0xe>
      return (char*)s;
  return 0;
 1a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ae:	5d                   	pop    %ebp
 1af:	c3                   	ret    

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	f3 0f 1e fb          	endbr32 
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	83 ec 1c             	sub    $0x1c,%esp
 1bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	bb 00 00 00 00       	mov    $0x0,%ebx
 1c5:	89 de                	mov    %ebx,%esi
 1c7:	83 c3 01             	add    $0x1,%ebx
 1ca:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cd:	7d 2e                	jge    1fd <gets+0x4d>
    cc = read(0, &c, 1);
 1cf:	83 ec 04             	sub    $0x4,%esp
 1d2:	6a 01                	push   $0x1
 1d4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1d7:	50                   	push   %eax
 1d8:	6a 00                	push   $0x0
 1da:	e8 cf 01 00 00       	call   3ae <read>
    if(cc < 1)
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	85 c0                	test   %eax,%eax
 1e4:	7e 17                	jle    1fd <gets+0x4d>
      break;
    buf[i++] = c;
 1e6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1ea:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1ed:	3c 0a                	cmp    $0xa,%al
 1ef:	0f 94 c2             	sete   %dl
 1f2:	3c 0d                	cmp    $0xd,%al
 1f4:	0f 94 c0             	sete   %al
 1f7:	08 c2                	or     %al,%dl
 1f9:	74 ca                	je     1c5 <gets+0x15>
    buf[i++] = c;
 1fb:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1fd:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 201:	89 f8                	mov    %edi,%eax
 203:	8d 65 f4             	lea    -0xc(%ebp),%esp
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5f                   	pop    %edi
 209:	5d                   	pop    %ebp
 20a:	c3                   	ret    

0000020b <stat>:

int
stat(char *n, struct stat *st)
{
 20b:	f3 0f 1e fb          	endbr32 
 20f:	55                   	push   %ebp
 210:	89 e5                	mov    %esp,%ebp
 212:	56                   	push   %esi
 213:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 214:	83 ec 08             	sub    $0x8,%esp
 217:	6a 00                	push   $0x0
 219:	ff 75 08             	pushl  0x8(%ebp)
 21c:	e8 b5 01 00 00       	call   3d6 <open>
  if(fd < 0)
 221:	83 c4 10             	add    $0x10,%esp
 224:	85 c0                	test   %eax,%eax
 226:	78 24                	js     24c <stat+0x41>
 228:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 22a:	83 ec 08             	sub    $0x8,%esp
 22d:	ff 75 0c             	pushl  0xc(%ebp)
 230:	50                   	push   %eax
 231:	e8 b8 01 00 00       	call   3ee <fstat>
 236:	89 c6                	mov    %eax,%esi
  close(fd);
 238:	89 1c 24             	mov    %ebx,(%esp)
 23b:	e8 7e 01 00 00       	call   3be <close>
  return r;
 240:	83 c4 10             	add    $0x10,%esp
}
 243:	89 f0                	mov    %esi,%eax
 245:	8d 65 f8             	lea    -0x8(%ebp),%esp
 248:	5b                   	pop    %ebx
 249:	5e                   	pop    %esi
 24a:	5d                   	pop    %ebp
 24b:	c3                   	ret    
    return -1;
 24c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 251:	eb f0                	jmp    243 <stat+0x38>

00000253 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 253:	f3 0f 1e fb          	endbr32 
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	57                   	push   %edi
 25b:	56                   	push   %esi
 25c:	53                   	push   %ebx
 25d:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 260:	0f b6 02             	movzbl (%edx),%eax
 263:	3c 20                	cmp    $0x20,%al
 265:	75 05                	jne    26c <atoi+0x19>
 267:	83 c2 01             	add    $0x1,%edx
 26a:	eb f4                	jmp    260 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 26c:	3c 2d                	cmp    $0x2d,%al
 26e:	74 1d                	je     28d <atoi+0x3a>
 270:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 275:	3c 2b                	cmp    $0x2b,%al
 277:	0f 94 c1             	sete   %cl
 27a:	3c 2d                	cmp    $0x2d,%al
 27c:	0f 94 c0             	sete   %al
 27f:	08 c1                	or     %al,%cl
 281:	74 03                	je     286 <atoi+0x33>
    s++;
 283:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 286:	b8 00 00 00 00       	mov    $0x0,%eax
 28b:	eb 17                	jmp    2a4 <atoi+0x51>
 28d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 292:	eb e1                	jmp    275 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 294:	8d 34 80             	lea    (%eax,%eax,4),%esi
 297:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 29a:	83 c2 01             	add    $0x1,%edx
 29d:	0f be c9             	movsbl %cl,%ecx
 2a0:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 2a4:	0f b6 0a             	movzbl (%edx),%ecx
 2a7:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2aa:	80 fb 09             	cmp    $0x9,%bl
 2ad:	76 e5                	jbe    294 <atoi+0x41>
  return sign*n;
 2af:	0f af c7             	imul   %edi,%eax
}
 2b2:	5b                   	pop    %ebx
 2b3:	5e                   	pop    %esi
 2b4:	5f                   	pop    %edi
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    

000002b7 <atoo>:

int
atoo(const char *s)
{
 2b7:	f3 0f 1e fb          	endbr32 
 2bb:	55                   	push   %ebp
 2bc:	89 e5                	mov    %esp,%ebp
 2be:	57                   	push   %edi
 2bf:	56                   	push   %esi
 2c0:	53                   	push   %ebx
 2c1:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2c4:	0f b6 0a             	movzbl (%edx),%ecx
 2c7:	80 f9 20             	cmp    $0x20,%cl
 2ca:	75 05                	jne    2d1 <atoo+0x1a>
 2cc:	83 c2 01             	add    $0x1,%edx
 2cf:	eb f3                	jmp    2c4 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 2d1:	80 f9 2d             	cmp    $0x2d,%cl
 2d4:	74 23                	je     2f9 <atoo+0x42>
 2d6:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2db:	80 f9 2b             	cmp    $0x2b,%cl
 2de:	0f 94 c0             	sete   %al
 2e1:	89 c6                	mov    %eax,%esi
 2e3:	80 f9 2d             	cmp    $0x2d,%cl
 2e6:	0f 94 c0             	sete   %al
 2e9:	89 f3                	mov    %esi,%ebx
 2eb:	08 c3                	or     %al,%bl
 2ed:	74 03                	je     2f2 <atoo+0x3b>
    s++;
 2ef:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2f2:	b8 00 00 00 00       	mov    $0x0,%eax
 2f7:	eb 11                	jmp    30a <atoo+0x53>
 2f9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2fe:	eb db                	jmp    2db <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 300:	83 c2 01             	add    $0x1,%edx
 303:	0f be c9             	movsbl %cl,%ecx
 306:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 30a:	0f b6 0a             	movzbl (%edx),%ecx
 30d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 310:	80 fb 07             	cmp    $0x7,%bl
 313:	76 eb                	jbe    300 <atoo+0x49>
  return sign*n;
 315:	0f af c7             	imul   %edi,%eax
}
 318:	5b                   	pop    %ebx
 319:	5e                   	pop    %esi
 31a:	5f                   	pop    %edi
 31b:	5d                   	pop    %ebp
 31c:	c3                   	ret    

0000031d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 31d:	f3 0f 1e fb          	endbr32 
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	53                   	push   %ebx
 325:	8b 55 08             	mov    0x8(%ebp),%edx
 328:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 32b:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 32e:	eb 09                	jmp    339 <strncmp+0x1c>
      n--, p++, q++;
 330:	83 e8 01             	sub    $0x1,%eax
 333:	83 c2 01             	add    $0x1,%edx
 336:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 339:	85 c0                	test   %eax,%eax
 33b:	74 0b                	je     348 <strncmp+0x2b>
 33d:	0f b6 1a             	movzbl (%edx),%ebx
 340:	84 db                	test   %bl,%bl
 342:	74 04                	je     348 <strncmp+0x2b>
 344:	3a 19                	cmp    (%ecx),%bl
 346:	74 e8                	je     330 <strncmp+0x13>
    if(n == 0)
 348:	85 c0                	test   %eax,%eax
 34a:	74 0b                	je     357 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 34c:	0f b6 02             	movzbl (%edx),%eax
 34f:	0f b6 11             	movzbl (%ecx),%edx
 352:	29 d0                	sub    %edx,%eax
}
 354:	5b                   	pop    %ebx
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
      return 0;
 357:	b8 00 00 00 00       	mov    $0x0,%eax
 35c:	eb f6                	jmp    354 <strncmp+0x37>

0000035e <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 35e:	f3 0f 1e fb          	endbr32 
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	56                   	push   %esi
 366:	53                   	push   %ebx
 367:	8b 75 08             	mov    0x8(%ebp),%esi
 36a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 36d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 370:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 372:	8d 58 ff             	lea    -0x1(%eax),%ebx
 375:	85 c0                	test   %eax,%eax
 377:	7e 0f                	jle    388 <memmove+0x2a>
    *dst++ = *src++;
 379:	0f b6 01             	movzbl (%ecx),%eax
 37c:	88 02                	mov    %al,(%edx)
 37e:	8d 49 01             	lea    0x1(%ecx),%ecx
 381:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 384:	89 d8                	mov    %ebx,%eax
 386:	eb ea                	jmp    372 <memmove+0x14>
  return vdst;
}
 388:	89 f0                	mov    %esi,%eax
 38a:	5b                   	pop    %ebx
 38b:	5e                   	pop    %esi
 38c:	5d                   	pop    %ebp
 38d:	c3                   	ret    

0000038e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38e:	b8 01 00 00 00       	mov    $0x1,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <exit>:
SYSCALL(exit)
 396:	b8 02 00 00 00       	mov    $0x2,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <wait>:
SYSCALL(wait)
 39e:	b8 03 00 00 00       	mov    $0x3,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <pipe>:
SYSCALL(pipe)
 3a6:	b8 04 00 00 00       	mov    $0x4,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <read>:
SYSCALL(read)
 3ae:	b8 05 00 00 00       	mov    $0x5,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <write>:
SYSCALL(write)
 3b6:	b8 10 00 00 00       	mov    $0x10,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <close>:
SYSCALL(close)
 3be:	b8 15 00 00 00       	mov    $0x15,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <kill>:
SYSCALL(kill)
 3c6:	b8 06 00 00 00       	mov    $0x6,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <exec>:
SYSCALL(exec)
 3ce:	b8 07 00 00 00       	mov    $0x7,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <open>:
SYSCALL(open)
 3d6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <mknod>:
SYSCALL(mknod)
 3de:	b8 11 00 00 00       	mov    $0x11,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <unlink>:
SYSCALL(unlink)
 3e6:	b8 12 00 00 00       	mov    $0x12,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <fstat>:
SYSCALL(fstat)
 3ee:	b8 08 00 00 00       	mov    $0x8,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <link>:
SYSCALL(link)
 3f6:	b8 13 00 00 00       	mov    $0x13,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <mkdir>:
SYSCALL(mkdir)
 3fe:	b8 14 00 00 00       	mov    $0x14,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <chdir>:
SYSCALL(chdir)
 406:	b8 09 00 00 00       	mov    $0x9,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <dup>:
SYSCALL(dup)
 40e:	b8 0a 00 00 00       	mov    $0xa,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <getpid>:
SYSCALL(getpid)
 416:	b8 0b 00 00 00       	mov    $0xb,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <sbrk>:
SYSCALL(sbrk)
 41e:	b8 0c 00 00 00       	mov    $0xc,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <sleep>:
SYSCALL(sleep)
 426:	b8 0d 00 00 00       	mov    $0xd,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <uptime>:
SYSCALL(uptime)
 42e:	b8 0e 00 00 00       	mov    $0xe,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <halt>:
SYSCALL(halt)
 436:	b8 16 00 00 00       	mov    $0x16,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <date>:
SYSCALL(date)
 43e:	b8 17 00 00 00       	mov    $0x17,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <getuid>:
SYSCALL(getuid)
 446:	b8 18 00 00 00       	mov    $0x18,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <getgid>:
SYSCALL(getgid)
 44e:	b8 19 00 00 00       	mov    $0x19,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <getppid>:
SYSCALL(getppid)
 456:	b8 1a 00 00 00       	mov    $0x1a,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <setuid>:
SYSCALL(setuid)
 45e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <setgid>:
SYSCALL(setgid)
 466:	b8 1c 00 00 00       	mov    $0x1c,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <getprocs>:
SYSCALL(getprocs)
 46e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <setpriority>:
SYSCALL(setpriority)
 476:	b8 1e 00 00 00       	mov    $0x1e,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <getpriority>:
SYSCALL(getpriority)
 47e:	b8 1f 00 00 00       	mov    $0x1f,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 486:	55                   	push   %ebp
 487:	89 e5                	mov    %esp,%ebp
 489:	83 ec 1c             	sub    $0x1c,%esp
 48c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 48f:	6a 01                	push   $0x1
 491:	8d 55 f4             	lea    -0xc(%ebp),%edx
 494:	52                   	push   %edx
 495:	50                   	push   %eax
 496:	e8 1b ff ff ff       	call   3b6 <write>
}
 49b:	83 c4 10             	add    $0x10,%esp
 49e:	c9                   	leave  
 49f:	c3                   	ret    

000004a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 2c             	sub    $0x2c,%esp
 4a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4ac:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4b2:	0f 95 c2             	setne  %dl
 4b5:	89 f0                	mov    %esi,%eax
 4b7:	c1 e8 1f             	shr    $0x1f,%eax
 4ba:	84 c2                	test   %al,%dl
 4bc:	74 42                	je     500 <printint+0x60>
    neg = 1;
    x = -xx;
 4be:	f7 de                	neg    %esi
    neg = 1;
 4c0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 4cc:	89 f0                	mov    %esi,%eax
 4ce:	ba 00 00 00 00       	mov    $0x0,%edx
 4d3:	f7 f1                	div    %ecx
 4d5:	89 df                	mov    %ebx,%edi
 4d7:	83 c3 01             	add    $0x1,%ebx
 4da:	0f b6 92 24 08 00 00 	movzbl 0x824(%edx),%edx
 4e1:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 4e5:	89 f2                	mov    %esi,%edx
 4e7:	89 c6                	mov    %eax,%esi
 4e9:	39 d1                	cmp    %edx,%ecx
 4eb:	76 df                	jbe    4cc <printint+0x2c>
  if(neg)
 4ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4f1:	74 2f                	je     522 <printint+0x82>
    buf[i++] = '-';
 4f3:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4f8:	8d 5f 02             	lea    0x2(%edi),%ebx
 4fb:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4fe:	eb 15                	jmp    515 <printint+0x75>
  neg = 0;
 500:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 507:	eb be                	jmp    4c7 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 509:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 50e:	89 f0                	mov    %esi,%eax
 510:	e8 71 ff ff ff       	call   486 <putc>
  while(--i >= 0)
 515:	83 eb 01             	sub    $0x1,%ebx
 518:	79 ef                	jns    509 <printint+0x69>
}
 51a:	83 c4 2c             	add    $0x2c,%esp
 51d:	5b                   	pop    %ebx
 51e:	5e                   	pop    %esi
 51f:	5f                   	pop    %edi
 520:	5d                   	pop    %ebp
 521:	c3                   	ret    
 522:	8b 75 d0             	mov    -0x30(%ebp),%esi
 525:	eb ee                	jmp    515 <printint+0x75>

00000527 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 527:	f3 0f 1e fb          	endbr32 
 52b:	55                   	push   %ebp
 52c:	89 e5                	mov    %esp,%ebp
 52e:	57                   	push   %edi
 52f:	56                   	push   %esi
 530:	53                   	push   %ebx
 531:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 534:	8d 45 10             	lea    0x10(%ebp),%eax
 537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 53a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 53f:	bb 00 00 00 00       	mov    $0x0,%ebx
 544:	eb 14                	jmp    55a <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 546:	89 fa                	mov    %edi,%edx
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	e8 36 ff ff ff       	call   486 <putc>
 550:	eb 05                	jmp    557 <printf+0x30>
      }
    } else if(state == '%'){
 552:	83 fe 25             	cmp    $0x25,%esi
 555:	74 25                	je     57c <printf+0x55>
  for(i = 0; fmt[i]; i++){
 557:	83 c3 01             	add    $0x1,%ebx
 55a:	8b 45 0c             	mov    0xc(%ebp),%eax
 55d:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 561:	84 c0                	test   %al,%al
 563:	0f 84 23 01 00 00    	je     68c <printf+0x165>
    c = fmt[i] & 0xff;
 569:	0f be f8             	movsbl %al,%edi
 56c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 56f:	85 f6                	test   %esi,%esi
 571:	75 df                	jne    552 <printf+0x2b>
      if(c == '%'){
 573:	83 f8 25             	cmp    $0x25,%eax
 576:	75 ce                	jne    546 <printf+0x1f>
        state = '%';
 578:	89 c6                	mov    %eax,%esi
 57a:	eb db                	jmp    557 <printf+0x30>
      if(c == 'd'){
 57c:	83 f8 64             	cmp    $0x64,%eax
 57f:	74 49                	je     5ca <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 581:	83 f8 78             	cmp    $0x78,%eax
 584:	0f 94 c1             	sete   %cl
 587:	83 f8 70             	cmp    $0x70,%eax
 58a:	0f 94 c2             	sete   %dl
 58d:	08 d1                	or     %dl,%cl
 58f:	75 63                	jne    5f4 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 591:	83 f8 73             	cmp    $0x73,%eax
 594:	0f 84 84 00 00 00    	je     61e <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59a:	83 f8 63             	cmp    $0x63,%eax
 59d:	0f 84 b7 00 00 00    	je     65a <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5a3:	83 f8 25             	cmp    $0x25,%eax
 5a6:	0f 84 cc 00 00 00    	je     678 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ac:	ba 25 00 00 00       	mov    $0x25,%edx
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
 5b4:	e8 cd fe ff ff       	call   486 <putc>
        putc(fd, c);
 5b9:	89 fa                	mov    %edi,%edx
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
 5be:	e8 c3 fe ff ff       	call   486 <putc>
      }
      state = 0;
 5c3:	be 00 00 00 00       	mov    $0x0,%esi
 5c8:	eb 8d                	jmp    557 <printf+0x30>
        printint(fd, *ap, 10, 1);
 5ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5cd:	8b 17                	mov    (%edi),%edx
 5cf:	83 ec 0c             	sub    $0xc,%esp
 5d2:	6a 01                	push   $0x1
 5d4:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	e8 bf fe ff ff       	call   4a0 <printint>
        ap++;
 5e1:	83 c7 04             	add    $0x4,%edi
 5e4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5e7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ea:	be 00 00 00 00       	mov    $0x0,%esi
 5ef:	e9 63 ff ff ff       	jmp    557 <printf+0x30>
        printint(fd, *ap, 16, 0);
 5f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5f7:	8b 17                	mov    (%edi),%edx
 5f9:	83 ec 0c             	sub    $0xc,%esp
 5fc:	6a 00                	push   $0x0
 5fe:	b9 10 00 00 00       	mov    $0x10,%ecx
 603:	8b 45 08             	mov    0x8(%ebp),%eax
 606:	e8 95 fe ff ff       	call   4a0 <printint>
        ap++;
 60b:	83 c7 04             	add    $0x4,%edi
 60e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 611:	83 c4 10             	add    $0x10,%esp
      state = 0;
 614:	be 00 00 00 00       	mov    $0x0,%esi
 619:	e9 39 ff ff ff       	jmp    557 <printf+0x30>
        s = (char*)*ap;
 61e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 621:	8b 30                	mov    (%eax),%esi
        ap++;
 623:	83 c0 04             	add    $0x4,%eax
 626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 629:	85 f6                	test   %esi,%esi
 62b:	75 28                	jne    655 <printf+0x12e>
          s = "(null)";
 62d:	be 1c 08 00 00       	mov    $0x81c,%esi
 632:	8b 7d 08             	mov    0x8(%ebp),%edi
 635:	eb 0d                	jmp    644 <printf+0x11d>
          putc(fd, *s);
 637:	0f be d2             	movsbl %dl,%edx
 63a:	89 f8                	mov    %edi,%eax
 63c:	e8 45 fe ff ff       	call   486 <putc>
          s++;
 641:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 644:	0f b6 16             	movzbl (%esi),%edx
 647:	84 d2                	test   %dl,%dl
 649:	75 ec                	jne    637 <printf+0x110>
      state = 0;
 64b:	be 00 00 00 00       	mov    $0x0,%esi
 650:	e9 02 ff ff ff       	jmp    557 <printf+0x30>
 655:	8b 7d 08             	mov    0x8(%ebp),%edi
 658:	eb ea                	jmp    644 <printf+0x11d>
        putc(fd, *ap);
 65a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 65d:	0f be 17             	movsbl (%edi),%edx
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	e8 1e fe ff ff       	call   486 <putc>
        ap++;
 668:	83 c7 04             	add    $0x4,%edi
 66b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 66e:	be 00 00 00 00       	mov    $0x0,%esi
 673:	e9 df fe ff ff       	jmp    557 <printf+0x30>
        putc(fd, c);
 678:	89 fa                	mov    %edi,%edx
 67a:	8b 45 08             	mov    0x8(%ebp),%eax
 67d:	e8 04 fe ff ff       	call   486 <putc>
      state = 0;
 682:	be 00 00 00 00       	mov    $0x0,%esi
 687:	e9 cb fe ff ff       	jmp    557 <printf+0x30>
    }
  }
}
 68c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68f:	5b                   	pop    %ebx
 690:	5e                   	pop    %esi
 691:	5f                   	pop    %edi
 692:	5d                   	pop    %ebp
 693:	c3                   	ret    

00000694 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 694:	f3 0f 1e fb          	endbr32 
 698:	55                   	push   %ebp
 699:	89 e5                	mov    %esp,%ebp
 69b:	57                   	push   %edi
 69c:	56                   	push   %esi
 69d:	53                   	push   %ebx
 69e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a4:	a1 60 0b 00 00       	mov    0xb60,%eax
 6a9:	eb 02                	jmp    6ad <free+0x19>
 6ab:	89 d0                	mov    %edx,%eax
 6ad:	39 c8                	cmp    %ecx,%eax
 6af:	73 04                	jae    6b5 <free+0x21>
 6b1:	39 08                	cmp    %ecx,(%eax)
 6b3:	77 12                	ja     6c7 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b5:	8b 10                	mov    (%eax),%edx
 6b7:	39 c2                	cmp    %eax,%edx
 6b9:	77 f0                	ja     6ab <free+0x17>
 6bb:	39 c8                	cmp    %ecx,%eax
 6bd:	72 08                	jb     6c7 <free+0x33>
 6bf:	39 ca                	cmp    %ecx,%edx
 6c1:	77 04                	ja     6c7 <free+0x33>
 6c3:	89 d0                	mov    %edx,%eax
 6c5:	eb e6                	jmp    6ad <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c7:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6ca:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6cd:	8b 10                	mov    (%eax),%edx
 6cf:	39 d7                	cmp    %edx,%edi
 6d1:	74 19                	je     6ec <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6d3:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6d6:	8b 50 04             	mov    0x4(%eax),%edx
 6d9:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6dc:	39 ce                	cmp    %ecx,%esi
 6de:	74 1b                	je     6fb <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6e0:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6e2:	a3 60 0b 00 00       	mov    %eax,0xb60
}
 6e7:	5b                   	pop    %ebx
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6ec:	03 72 04             	add    0x4(%edx),%esi
 6ef:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f2:	8b 10                	mov    (%eax),%edx
 6f4:	8b 12                	mov    (%edx),%edx
 6f6:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6f9:	eb db                	jmp    6d6 <free+0x42>
    p->s.size += bp->s.size;
 6fb:	03 53 fc             	add    -0x4(%ebx),%edx
 6fe:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 701:	8b 53 f8             	mov    -0x8(%ebx),%edx
 704:	89 10                	mov    %edx,(%eax)
 706:	eb da                	jmp    6e2 <free+0x4e>

00000708 <morecore>:

static Header*
morecore(uint nu)
{
 708:	55                   	push   %ebp
 709:	89 e5                	mov    %esp,%ebp
 70b:	53                   	push   %ebx
 70c:	83 ec 04             	sub    $0x4,%esp
 70f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 711:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 716:	77 05                	ja     71d <morecore+0x15>
    nu = 4096;
 718:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 71d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 724:	83 ec 0c             	sub    $0xc,%esp
 727:	50                   	push   %eax
 728:	e8 f1 fc ff ff       	call   41e <sbrk>
  if(p == (char*)-1)
 72d:	83 c4 10             	add    $0x10,%esp
 730:	83 f8 ff             	cmp    $0xffffffff,%eax
 733:	74 1c                	je     751 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 735:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 738:	83 c0 08             	add    $0x8,%eax
 73b:	83 ec 0c             	sub    $0xc,%esp
 73e:	50                   	push   %eax
 73f:	e8 50 ff ff ff       	call   694 <free>
  return freep;
 744:	a1 60 0b 00 00       	mov    0xb60,%eax
 749:	83 c4 10             	add    $0x10,%esp
}
 74c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 74f:	c9                   	leave  
 750:	c3                   	ret    
    return 0;
 751:	b8 00 00 00 00       	mov    $0x0,%eax
 756:	eb f4                	jmp    74c <morecore+0x44>

00000758 <malloc>:

void*
malloc(uint nbytes)
{
 758:	f3 0f 1e fb          	endbr32 
 75c:	55                   	push   %ebp
 75d:	89 e5                	mov    %esp,%ebp
 75f:	53                   	push   %ebx
 760:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 763:	8b 45 08             	mov    0x8(%ebp),%eax
 766:	8d 58 07             	lea    0x7(%eax),%ebx
 769:	c1 eb 03             	shr    $0x3,%ebx
 76c:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 76f:	8b 0d 60 0b 00 00    	mov    0xb60,%ecx
 775:	85 c9                	test   %ecx,%ecx
 777:	74 04                	je     77d <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 779:	8b 01                	mov    (%ecx),%eax
 77b:	eb 4b                	jmp    7c8 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 77d:	c7 05 60 0b 00 00 64 	movl   $0xb64,0xb60
 784:	0b 00 00 
 787:	c7 05 64 0b 00 00 64 	movl   $0xb64,0xb64
 78e:	0b 00 00 
    base.s.size = 0;
 791:	c7 05 68 0b 00 00 00 	movl   $0x0,0xb68
 798:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 79b:	b9 64 0b 00 00       	mov    $0xb64,%ecx
 7a0:	eb d7                	jmp    779 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 7a2:	74 1a                	je     7be <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7a4:	29 da                	sub    %ebx,%edx
 7a6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a9:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 7ac:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7af:	89 0d 60 0b 00 00    	mov    %ecx,0xb60
      return (void*)(p + 1);
 7b5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b8:	83 c4 04             	add    $0x4,%esp
 7bb:	5b                   	pop    %ebx
 7bc:	5d                   	pop    %ebp
 7bd:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 7be:	8b 10                	mov    (%eax),%edx
 7c0:	89 11                	mov    %edx,(%ecx)
 7c2:	eb eb                	jmp    7af <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	89 c1                	mov    %eax,%ecx
 7c6:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 7c8:	8b 50 04             	mov    0x4(%eax),%edx
 7cb:	39 da                	cmp    %ebx,%edx
 7cd:	73 d3                	jae    7a2 <malloc+0x4a>
    if(p == freep)
 7cf:	39 05 60 0b 00 00    	cmp    %eax,0xb60
 7d5:	75 ed                	jne    7c4 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 7d7:	89 d8                	mov    %ebx,%eax
 7d9:	e8 2a ff ff ff       	call   708 <morecore>
 7de:	85 c0                	test   %eax,%eax
 7e0:	75 e2                	jne    7c4 <malloc+0x6c>
 7e2:	eb d4                	jmp    7b8 <malloc+0x60>
