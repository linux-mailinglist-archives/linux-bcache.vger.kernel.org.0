Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E611937AF10
	for <lists+linux-bcache@lfdr.de>; Tue, 11 May 2021 21:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhEKTHe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 11 May 2021 15:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbhEKTHc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 May 2021 15:07:32 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65EAC061574
        for <linux-bcache@vger.kernel.org>; Tue, 11 May 2021 12:06:24 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id x9so6701361uao.3
        for <linux-bcache@vger.kernel.org>; Tue, 11 May 2021 12:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=F76vG1gC7d8o85NuUCHS0JQi8tlB4XaKklqFSK0fkm4=;
        b=ZyJKo23ZrkD3EA5+UltBKjPEfle1l48iB7c1pkZZrpWeZMNDiRJZ7AlIyeMWRtklZ8
         I56LoDYwmrD74xkpInaYe4D6el6Jc2xM79QjTs1E9IA4/MZOEoR7nDSUV39IOCTQY3Kq
         S3N0EGErWUF3Useu8MAYbj+PTO///Tw7ZkjCXgBCOWYAh+g17KtdXtloIpm2QZWlhv0u
         tje5fJU3s7v+LWvuOb24BXb+rlxrm5ocDd9TQbFX4FcE1hmhmYy2Szoie2xW2ZAivM7o
         k1rqoewxpAE8r2EMuAzWKm3LxZmwn/rRyuVRM2fd6SkW+wX9ujM8Jgwa6SSXMDUKXW1+
         EwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=F76vG1gC7d8o85NuUCHS0JQi8tlB4XaKklqFSK0fkm4=;
        b=JdWc7acerdZK/GutR07kht57wgBEiJyhq9voOFlqq6Ne93aqiPbeIl6k54O3DABvnT
         DWqGlvz/EwFpFrNPJ5C7D/Y/z1zqQN9elDOoELNTv4vxGkILoUsvjJ2YRySawbQIieVy
         FDfJdroNREE96KR3z/L5YJQK69rszjSgnH/6/NVf4NpztsXoshAC+j/KIeQWUAWOmebA
         ORMb2oq+9ibBTS4zWweWXi2LtC4H/X7tyjFZPityvkTkbxMacHuILCm9pvaq8r8nEFPc
         YVO4HnWZwvqilJrrdRaIFoJRS4Tr+Q7u/cRxu4Sn3v9CBEljV8fwk25qyuaunavFj8uy
         CCSw==
X-Gm-Message-State: AOAM530lMENnDmKZthLL+tT0woxR3UVFdbDvmtt/yUD/NTq35alM615u
        hn2guNz7q8LpJ3qWA47kCAct19UYDmIbIKrOxHzRR3TFM8I=
X-Google-Smtp-Source: ABdhPJzVCG/RgZcY0PJtfEv0ItcTqso09V99fMOZq4QXiXQQctfmK2T5rxCU/q0EcK3zC0AOmkuh8nEJihGTsZ9fPDQ=
X-Received: by 2002:ab0:5a61:: with SMTP id m30mr27013359uad.125.1620759983605;
 Tue, 11 May 2021 12:06:23 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Tue, 11 May 2021 15:06:12 -0400
Message-ID: <CAH6h+he=rxPq9E8zmenmLp9vc9X4D1-6OQqVm0XyeMei3uLgqg@mail.gmail.com>
Subject: [PATCH] bcache-tools: bcache-export-cached doesn't match backing
 device w/ offset, features
To:     linux-bcache <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

updated the awk snippet used in 'bcache-export-cached' so it matches the three
current superblock versions of a "backing" device (BCACHE_SB_VERSION_BDEV,
BCACHE_SB_VERSION_BDEV_WITH_OFFSET, BCACHE_SB_VERSION_BDEV_WITH_FEATURES)

Signed-off-by: Marc A. Smith <marc.smith@quantum.com>
---
 bcache-export-cached | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bcache-export-cached b/bcache-export-cached
index b345922..e6c1bc3 100644
--- a/bcache-export-cached
+++ b/bcache-export-cached
@@ -19,7 +19,7 @@ for slave in "/sys/class/block/$DEVNAME/slaves"/*; do
             $1 == "dev.uuid" { uuid=$2; }
             $1 == "dev.label" && $2 != "(empty)" { label=$2; }
             END {
-                if (sbver == 1 && uuid) {
+                if ((sbver == 1 || sbver == 4 || sbver == 6) && uuid) {
                     print("CACHED_UUID=" uuid)
                     if (label) print("CACHED_LABEL=" label)
                     exit(0)
-- 
2.20.1
