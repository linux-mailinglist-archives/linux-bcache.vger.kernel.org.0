Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320582192BD
	for <lists+linux-bcache@lfdr.de>; Wed,  8 Jul 2020 23:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGHVqC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 8 Jul 2020 17:46:02 -0400
Received: from mout.gmx.net ([212.227.17.20]:58307 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgGHVqB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Jul 2020 17:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594244760;
        bh=JImgEEk3ZmPw8i6aLiZieFOkgVuG6PXoVaPKnNT/ucE=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=H0nVeeTjf8cYQIu8v/0TgOHIHBbo7wZhdvEU9jXZjnOip7wzYnBAznDa2nJIL1gKB
         IioqO5GLkkKyxKFJDrd+5nZ33mzIdKKsDIFU5jvvK0/p4lF+iesN/m+MkkAR+azKS3
         W81MVMKXqy8F2Q3CbgEfkXFHAbJvjr+iHYjoWCcs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from t460-skr.localnet ([88.78.23.144]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MjjCF-1kdIp92h4N-00lDBg for
 <linux-bcache@vger.kernel.org>; Wed, 08 Jul 2020 23:46:00 +0200
From:   Stefan K <shadow_7@gmx.net>
To:     linux-bcache@vger.kernel.org
Subject: how does the caching works in bcachefs
Date:   Wed, 08 Jul 2020 23:46:00 +0200
Message-ID: <2308642.L3yuttUQlX@t460-skr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:bJn3lyqDYRICADGr8LUzknt9Qw+Nfp8PqdUk9baR7BGxsgkzwBu
 8Tiru+g9D33nLTzHNoglIcgqLHq3rz2bFW17kv5KVmiaIdGoNgAuUgfHsB5O9pfpEI50pZd
 4Zqj8rckjkMaFxPSYGxNjM2P+I2XZQcJqVWZ0DFV97XdJXsLzYjNTLYDYjhQdPVfQv6CoU8
 VRYs/WWIX1089SwR2WzJQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9XA7J7lG07w=:X5HIDvyALSBgd5axhGNJDk
 C2lzl0Q3QU6NZsReZZCRT7/gP0wvCytKXIXx/ekPgDvRf1NyOKjG9xk9GjhF+3YWjXtr+4WSO
 E2R7+d2PrrNQkf7WyZqAACEgCZXQ2e+kFT40+LJe/pcVJQtUQrmFWIMduOVmJeoHZliCk/jTa
 EXGn7dSbR6VeFQGPytxhkbejxw9mn2x3WPiEfa82O5DrA91XHWQvEg6jKRywtczNH6aIm+11o
 mPLDxAh1HwglZk4CMKM039QleGiwEvi2Cpz/GSxYFZNTrh2PMQsS+oKVEqusjv11N1qXqu7qh
 xWwVq6ElbcrDkq5UYrr4eUrCIQLS0IWWfBpD/FqWzRYyMTXsWe2KvWOoBPufHf09XryFeamAq
 ux2RojH2EUgK8VqJ/eNprIKaeD1oB3G9/Kgtsvqi3wsmGJbrK3zD0cVYpQMufkypA37LTbZI/
 Vk1shQeUglmwpFfRb71cWbhC2wxWiNgqd8YiKHK2t9WX1AAoZ3PmPkaMSNqVgL9KZs2y631ZT
 xfyQi7NS467e21zGjbaJnMl46c8nbOpogkoPl6X57dyLMbthDqoFtVQ5wYIaQvZw1DtHhuFcy
 CzZpASi6amVIUmhjxCRaRFLCVGAF1qIZooPKxowK08yKUubNKfvTXqeKbpoCR5Qr0ZRzz/C8P
 uokLHDXLy6Sn3dCPcDAouRDur88zm0z9CCCo2YTvhwhUQk2M0va7GHE4rE7OxWj37wKLadYnt
 lJAlxxoBEyH+NQgnGKDDWHb6v/YA6qZ/2701uuPtGBbMMJOo5FShN14m/1CMkKCkR7bHewQiW
 xphXojLKg/a9pJ6WF0nrwyf+63LlHHoc+B+9N7yhJ2Q4kE3WVVXWRCJC33Tchrc9h0OcKx6Ns
 6v9xkfScF8b1TelBmKia02Hs/G58AvjdG82cH3i3woUumOeOS1YYqXHjwMnzFGdafdqxG1wE/
 qi8+2QXU6EKAtozydiGr1w2ehSCDKpd+57OxsJ8vGLOLQhWtiZ7fpdd2Sp4QESppMJLyIiSpC
 KAYHPPjwmsgRZ8HbKW4/l3/KqCDAk5nEaKPj72LxCHJ8apgu0g16ztJaQV5+ASbx50Ff1kA8q
 kKvrkJJdzXLIcfEFn8zGdMAuqul8hoxGjuzkvk4N9gfwuES4fwrEo0E0an+iZXVi9zATqfV6g
 INnwMgPSVzGAcb40VfYLZ+BwIl2OqHdF5rfZ4wECmsFVkVq20PT2TqtlwtIxz0pIhVGkazKVh
 C7+LUzurt+7WBjwgO
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

short question: how does the caching works with bcachefs? Is it like  "first in first out" or is it more complex like the ARC system in zfs? The same with the write-cache,  will be everything written to the SSD/NVMe (Cache) and then to the HDD? When will will the filesystem say "its written to disk"? And what happens with the data on the write cache if we have a powerfail?

And can I say have this file/folder always in the cache, while it works "normal" ?

Thanks in advance!
best regards
Stefan


