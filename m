Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7A32480A
	for <lists+linux-bcache@lfdr.de>; Tue, 21 May 2019 08:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfEUG2F (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 May 2019 02:28:05 -0400
Received: from mout.gmx.net ([212.227.17.20]:40039 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfEUG2F (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 May 2019 02:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1558420083;
        bh=IjDE8lnA74SfRVdCVZ8QPv2ZslY1AYAa4MraZV1+IPw=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=cQZtTqq3KojXli4lZXbEtJVanWTRHTB0LT7IAWEXZwvT6MhTX1m2Qqvu9CWzMUVhg
         Yjtf4RCQVob+/sJscZScagVVVqDfaQefhRoCJzuYr9/4QKxd47igk/rn7H8/jd3EEZ
         nxkSY9BVoOGBvrfAl0+a3/bIFDYOFzczCcIwQB1Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MGoU1-1hOJXe2GGX-00DZ0r for
 <linux-bcache@vger.kernel.org>; Tue, 21 May 2019 08:28:03 +0200
From:   Stefan K <shadow_7@gmx.net>
To:     linux-bcache@vger.kernel.org
Subject: current status of bcachefs
Date:   Tue, 21 May 2019 08:28:03 +0200
Message-ID: <1561092.0S7j4aqO6R@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.19.0-0.bpo.2-amd64; KDE/5.28.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:TmB9ahxgqusIX5K+iypvDPFY9P2zw0Iy1qfFM5oC9nMSmZBs9YK
 8oq5ecQa3hhzPSNTx7hJ8N46KatVshVPjdOrnLUImmACXcJsXt7MPRwjolJNzWFpDsiwlOL
 ZjV125Q/mGsIKjBv+vNJZt2ONiU19cCNjt8J0sBTkO+QO7dcc8QpXON5kNKLEbnFVns7BKg
 Sxuwqc7B1iw7HS9gAcTfg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MmBuOSJE5NM=:CvrIc/9XhxedRlNWG1FE55
 Ims0u1Y2o4+bAe2t/TejLDHZO+v5rsFDjVbjZVGQnzWXRZ1Tx3GUufFz7qZp1IaXFmn8+lwow
 yf/378I6cp4TEtnRolSlx0Hkw/WMPQksh5sNo34dDiqxmnDhPrmXY68jA883vgKcuJwTSzFNU
 Z/8cqtUE1L9Cy6AQTKJP42ToNgANfAn1AxC/jJn6sEiJUGw29FBgO39Yk+xC5sDuZzGfDcwe0
 yK5BPL3JjbiZIp1PWEPl6AIfyUsP5SbU6wXLH5T1JFwH4PT8eW1FN5Vh9sotP13DltpFZUmbJ
 leXAcaQsUhkscdNDrCujAVdj5YT+TcUJOrFhcXQoEazV+MnVjR0d12WbhLap4pu1zHHqQtFiA
 MPfAT924n4zBq29KicvYFB3wfHH2R/+ZlQLi1H53S3nmCTfdUfUow8l+Dm6glpgC6nidOyghR
 ID59Er2K3AfSh4G3EyhBJOQPmtAP/Wg/yirntI9f6cc89wf/k6YbzHx5Txl7f7uyNQN26T5TF
 vc4AXC6Tnoj1y/2HWtaphakkG7LVZULkeJUB/RrKLoZb3aOPV65aKXeTMTQ6zohWQ6HccvAw1
 9GlqdZ233iyjWrmEhuWEjJhN6q43cHP2a+TTgv1onojl87MJCZXlZ0KQtFo29WAE6aUNne0/1
 VAW1DDuI9/RPiISY/XN4lEaLNs6r91I46DSCVaypy3Y8rBa1vsvBORpuqX9VKT2Ka8Ss0ab3t
 /WSsyVwcRozq2YkFAqowSuPj9xHUcWjFkvtdNIowHrga1M6reeurBxJVg0T96FBATXZD9O8gv
 E4qdIczQyimWWi9xInBeeiO423Wx2CMqxawD8ICuYgbBHsOCJcvTV8bHBGJbUIpBNdcGL18pX
 HgYF0GuYNL8y4e09x7Q5dGfxUYN7YYnXWz3kVauNISIXs2kggWNbum9omDcIoslcZW0VGL9YK
 T/H9RHIXiI7cUTHKmJVyyOcAQjYp2A3GZlxR48nDEt19NBhV13VzV
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

as I can read here[1] Kent is trying to get the bcachefs code into the Ker=
nel around mid of this year.
So kernel 5.2rc1 is out and there is no bcachefs code, will this come into=
 5.3 (end of July) ?

[1] https://lkml.org/lkml/2018/12/2/46

best regards
Stefan
