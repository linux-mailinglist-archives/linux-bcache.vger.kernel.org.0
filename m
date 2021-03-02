Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86132AF5D
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Mar 2021 04:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbhCCASV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Mar 2021 19:18:21 -0500
Received: from mout.gmx.net ([212.227.17.22]:56839 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379962AbhCBKWe (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Mar 2021 05:22:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614680430;
        bh=EUSMcnw5u/o+Z6hT7LQOufUgCnNkWu4J1JQzsagLmqc=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=IuwDsqsb9L+rW5w9PlJxixE0u+jN08tdSZcgxObEhYL5eL7CCfvfzZ3pK4JmDRruD
         67atTZ9vxn4CNB0drVrrCVYc329yaV+oA8xJ1GLHBhnUk5mSuDwd4pBudq86ACIi2x
         UgkDnSupRKd9AB+NERls/2nIY/NE+jaOxHJxRMiI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.213.91] ([103.52.188.137]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MK3Rm-1lUrlD221O-00LYO2; Tue, 02
 Mar 2021 11:20:30 +0100
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
From:   "Norman.Kern" <norman.kern@gmx.com>
Subject: Large latency with bcache for Ceph OSD(new mail thread)
Message-ID: <9b7dfd49-67b0-53b1-96e1-3b90c2d9d09a@gmx.com>
Date:   Tue, 2 Mar 2021 18:20:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:k+4Miwh80poaIHYO/bhJibu4nYsd4O1YdR/pm1MgII1iBgBXz5d
 bkALxAJD4jQMoJ9mPZBze2ylMYaIe22Aep6pNvMRo4wl/c8dqstc2EI6YbaQiLT8uOSEIUW
 4dul7Yv2SwEJtQahZTVjqhOT2/tBXIiOzsYH2SpP8WwX7FO7sb5TspgiWUelKgpTvnLG6iX
 Q78Yx+VbmeBOzCno4c6QQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BJxmL4zPfo4=:kc4yx+y0T9ezrx8MLWcw2W
 lU30R+y3uv/pEKCo2wqbqUrOwvTtHZAXDWuzZ3Oo1tbnLrGiE1hUW0kUmKNpDIJW/iAyIk/pv
 6+7Zk5KMfIuSrdSwMVCthLolEGfSvA39XAAyNqIo40U1MtSa7jSamgfOkg/uF09ciQxORf/xH
 NUPubIBzIvkF6TwWxWefDXXVJgOQJZqej9hNq3fNiOO+8QUImzYs4ZRx+W22cfhoNsDd6WNB4
 FvJSPGAsB2Ll/5ta4cZseNhbzmtRoF7UfYsl3rYQLG3wFQpHj/VfDYfflRZBwfVIkeXxMNCXp
 NaPCikTgaPBS1caNW5nB/zM3zHX4DXZfUsIXcXcN+L28R5858hgRFn9WsZXC1Hzxvtb+V7AzZ
 3oEsa0bYGoD/Inyioef/yBEaFXGYZpUJJOf/FdgHeeddhdCpdlzMa8471qWp+FcKZxjeD9Xoq
 qA4ji7XO0Dn1hdiQfYY1NiQaBew+OpESQ2akT2ulNxwHUU9kiXX7NgzWLVagsNC9tCff75YVl
 YLdO9k+dhY1WUQnyRvsj5Z5q5VMGATvfKCI+IDhBdb8dSwZE1Y3xrO1vkCURdbYoNGquiGvoE
 rLM0patp7R4AaEKN6UD68hRdWwaOJaMOt4uyZFWmVIMGiais4gxwmttStXPq+Y3TGmG0VwLG4
 rm5Kt4eOMeU2GszJ5PlWaf5iWsghbR7eRuEDwLr6SrRwum79bYPhCIV+mAP24Em0wGk/ukOAG
 YvmJWAgOTIjb/HDiTE7ODkhfqh/dh/SfBnRBGvqBYPLlwdAVyW/dAcipJR3AISAPYjc7NiOml
 b9ogTHKkwc+/jlrfnv17yMVvWs76i6igKjjO9sd5tXUFctxHUplDuwN3U7um+XC0iK8fdGZNG
 nA4JBkLfk9CN1vkpxrLQ==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Sorry for creating a new mail thread(the origin is so long...)


I made a test again and get more infomation:

root@WXS0089:~# cat /sys/block/bcache0/bcache/dirty_data
0.0k
root@WXS0089:~# lsblk /dev/sda
NAME=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MAJ:MIN RM=C2=A0=C2=A0 SIZE RO TYPE MOU=
NTPOINT
sda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8:0=C2=A0=C2=A0=C2=A0 =
0 447.1G=C2=A0 0 disk
`-bcache0 252:0=C2=A0=C2=A0=C2=A0 0=C2=A0 10.9T=C2=A0 0 disk
root@WXS0089:~# cat /sys/block/sda/bcache/priority_stats
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 29%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 70%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 49
Sectors per Q:=C2=A0 29184768
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [1 2 3 5 6 8 9 11 13 14 16 19 21 =
23 26 29 32 36 39 43 48 53 59 65 73 83 94 109 129 156 203]
root@WXS0089:~# cat /sys/fs/bcache/066319e1-8680-4b5b-adb8-49596319154b/in=
ternal/gc_after_writeback
1
You have new mail in /var/mail/root
root@WXS0089:~# cat /sys/fs/bcache/066319e1-8680-4b5b-adb8-49596319154b/ca=
che_available_percent
28

I read the source codes and found if cache_available_percent > 50, it shou=
ld wakeup gc while doing writeback, but it seemed not work right.

