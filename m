Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FE46C0BA
	for <lists+linux-bcache@lfdr.de>; Wed, 17 Jul 2019 20:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfGQSAo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 Jul 2019 14:00:44 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:37239 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfGQSAn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 Jul 2019 14:00:43 -0400
Received: by mail-wm1-f47.google.com with SMTP id f17so23042389wme.2
        for <linux-bcache@vger.kernel.org>; Wed, 17 Jul 2019 11:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=content-transfer-encoding:from:mime-version:message-id:date:subject
         :to;
        bh=+1uRya4mh3AYpF8B3dDDbibGxCOg2EELYcMtwg/kc2M=;
        b=X7JI3dbTtJ+ME9xh8AYLRmS20wOtUlQ9NhoQxWTwyJ49CEZhSB83dX0b5CK5TYfKsB
         eIGJ2j4fYp68kSvgocvXgkWtUrqdRJNjcbLOVoYG07ehWvJjDehO9iQSBw03RL/KwEfz
         3aldaV+LtVWNHskm4ZXFOcK1g/hCYGM4LWLQmDtoq+khmhOeRQe4rAmPNRJKKtnoi8sT
         Zm9EXw2yD2emaqzxmobBkTc9eyWpoghlxlZ4t+Odaet0zM1VcSJINjS7a1IfFlTNP8el
         eZVXKjD4AyXrKIb2O3r7a27Uaoh5u310cEDzvvpofNWGH52iBBmXJ4p4lRv5Q9YQ7/d8
         AlEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :message-id:date:subject:to;
        bh=+1uRya4mh3AYpF8B3dDDbibGxCOg2EELYcMtwg/kc2M=;
        b=K8ttWaS8kVLEOSAtldqTow/bvn820J1yHoKCv/rUmrS8OocarKtbUIV4jGyO3lZDgU
         5o014c8XNtK27dTT4/mxtVJBouYe6rqwSy+g72tQPTLWWI35eGYmkNo+IRR9oVcVfWfC
         1iajACOxyarmBYjMcvXT4FmwTBkZuTc3jGZcsp/8EnGZGptG7o7Fh2iAYt2yOtvsPTJH
         ug1FhzO9Qt3fXbxWuAsURcLSmJmI3gvSyqX0Mo9mLHHDQxVTGc5epR1223nvGz/S1Dq3
         TJfA6FXI9mXsDhFzfb3CQmYZMBGNrDZ9VySMbNqRGVI4Wjuq0AMrUDqw+Y0ZKClTdov4
         OLjQ==
X-Gm-Message-State: APjAAAWzQa5KZ988Sayx/AhrdnxFkN52n7v4l1hQPbjHpD9/EO/mwNWg
        tvMFW/lVHN/2Qz/4JwvkG1uQodBVVeA=
X-Google-Smtp-Source: APXvYqwHzWDlgWsdSZ/sWE9MQfjv0GUjB/aGYzbECB9hSSK7YvuCq8vzBXZ1BRb+j1S7opt6y8NGOw==
X-Received: by 2002:a1c:a1c5:: with SMTP id k188mr37791180wme.102.1563386441040;
        Wed, 17 Jul 2019 11:00:41 -0700 (PDT)
Received: from [192.168.99.36] ([92.116.115.139])
        by smtp.gmail.com with ESMTPSA id w23sm25848752wmi.45.2019.07.17.11.00.40
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 11:00:40 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
        charset=us-ascii
From:   Charalambos Sarantakis <chsarantakis@gmail.com>
Mime-Version: 1.0 (1.0)
Received: from [10.132.201.98] ([46.114.33.98]) by smtp.gmail.com with ESMTPSA id cw14sm5102040ejb.91.2019.07.17.10.57.45 for <linux-bache@vger.kernel.org> (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128); Wed, 17 Jul 2019 10:57:45 -0700 (PDT)
Message-Id: <AE5DFC97-6B0F-4E80-89D6-1A90AB0C8D7E@gmail.com>
Date:   Wed, 17 Jul 2019 20:00:39 +0200
X-Mailer: iPad Mail (16F203)
Subject: Bcachefs Feature Suggestion for a redundancy algorithm
To:     linux-bcache@vger.kernel.org
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I have a suggestion for an automatic redundancy algorithm in Bachefs.
Bachefs already has three different routes of devices,=20

My idea is a file system that uses the available free space to provide the m=
ax redundancy possible.=20
For example you have a 6 disk volume with 1TB disks having 6TB free space .A=
s long the stored data is not bigger than 1 TB the system would store 6 copi=
es of each file in the file system. When more data is added, the file system=
 would gradually deallocate copies, so the redundancy level would decrease.=20=

Some files would still have redundancy 6 others 5..=20
The redundancy decreases the more new data is written to the file system.

The file system should define a minimal redundancy level, When all files are=
 at the minimal redundancy level no copies would be deallocated and the file=
 system would have no free space anymore.
The point is I do not have to decide about a redundancy level in advance, I j=
ust have to expandstorage when minimal level is reached and I have always th=
e max possible redundancy.

Removing redundant copies should be a cheap operation, on the other hand  th=
e creation of copies would be expensive.=20
But as background volumes are accessed asynchronously this should be no prob=
lem.=20
I am not sure whether to have a redundancy level per file or per chunk,=20
Bcachefs has also erasure coding. So all tools are already there.=20
Free space calculation is no problem either. Sum of filecopy with index>=3Dm=
inredundancylevel
Probably the system should still keep free space which is not used for redun=
dancy.


Von meinem iPad gesendet
