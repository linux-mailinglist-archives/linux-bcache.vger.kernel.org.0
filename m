Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E37DF12A5E2
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Dec 2019 05:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfLYEeJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Dec 2019 23:34:09 -0500
Received: from mail.sajdowski.de ([2.59.135.178]:47664 "EHLO mail.sajdowski.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbfLYEeJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Dec 2019 23:34:09 -0500
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Dec 2019 23:34:08 EST
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pf-control.de;
        s=2019; t=1577248009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AjxqZiLNvKw5rkNEJZP8a36CSCXFdex1ooNlmoLHRgU=;
        b=jDVRnvdn3pxkgWlu2Sf67tshAwE2VoCYzSV6DA2xQtyqiCpnBIeouwdduab8dIy3LZdjwI
        WKWVsRK7Hz7j9BzNsNGnrzfv1juLaxKtGKwXCYGjv+qN5ObQJlkwovYvMp9VFLiO/v6Hqr
        oO5nI9s1A8W8bfJ0AukBjIIZ4j/vJ0ULi25WDkmPRQwVVzcy3M18MdYcUCie6wtH1Xednt
        5pCy1r1BTL6ljA3cHIEOWX+sPnE3YZlnB3Pl7WyRQ1NuPvx1qRK2vhsd0Q2yWL7q4R7BBt
        APgB9Ej3bDlPgYoBd5720bsIqtrK60xHzNjCziFSRGgYx40zHv79Jf3tlXUhkQ==
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Dec 2019 05:26:49 +0100
From:   Jonny <johnny@store.pf-control.de>
To:     linux-bcache@vger.kernel.org
Subject: Cant set sequential_cutoff
Message-ID: <758b3959ff2523615209506f9f23c2bb@store.pf-control.de>
X-Sender: johnny@store.pf-control.de
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Bcache is up and seems running, bcache-state is clean.

cat /sys/block/bcache0/bcache/sequential_cutoff
0.0k

This should not return 0.0k?
I tried to set it back to 4M, but get the following Error:

echo 4M > /sys/block/bcache0/bcache/sequential_cutoff
bash: echo: write error: Invalid argument


Thanks in Advance
