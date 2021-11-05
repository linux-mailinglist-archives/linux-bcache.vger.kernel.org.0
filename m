Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FB3446298
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Nov 2021 12:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhKELYD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 5 Nov 2021 07:24:03 -0400
Received: from forward105j.mail.yandex.net ([5.45.198.248]:35456 "EHLO
        forward105j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232115AbhKELYA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Nov 2021 07:24:00 -0400
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward105j.mail.yandex.net (Yandex) with ESMTP id 13DD64EC87A1
        for <linux-bcache@vger.kernel.org>; Fri,  5 Nov 2021 14:21:20 +0300 (MSK)
Received: from vla1-74593b5592df.qloud-c.yandex.net (vla1-74593b5592df.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:4d20:0:640:7459:3b55])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id 0EE226F40008
        for <linux-bcache@vger.kernel.org>; Fri,  5 Nov 2021 14:21:20 +0300 (MSK)
Received: from 2a02:6b8:c18:360d:0:640:f98f:ea90 (2a02:6b8:c18:360d:0:640:f98f:ea90 [2a02:6b8:c18:360d:0:640:f98f:ea90])
        by vla1-74593b5592df.qloud-c.yandex.net (mxback/Yandex) with HTTP id JLOrHG2Efa61-LJEGrk0w;
        Fri, 05 Nov 2021 14:21:19 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1636111279;
        bh=IFby+3wFpqtLFMW5qUnZaxZwTo2Oz7nshRCOw8KzjGI=;
        h=Message-Id:Date:Subject:To:From;
        b=npAiT8Fw+OEyOgOo4CY5Q2sWPpBm0zE0ulIMZYwUfFadkMiV1oZcRAzhZISJH5aDm
         d2HyhXSJOKjBal9M4JPfr9I2YUbd/Q2ktfB3U5/iZDXjw7mmM1RaTz/fPDMHvv3qs+
         EFVlH06sHabjZnda/3FgaKp3KC6QwIUF/A/ud1Og=
Authentication-Results: vla1-74593b5592df.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-f98fea902492.qloud-c.yandex.net with HTTP;
        Fri, 05 Nov 2021 14:21:19 +0300
From:   Aleksei Zakharov <zakharov.a.g@yandex.ru>
Envelope-From: zakharov-a-g@yandex.ru
To:     linux-bcache@vger.kernel.org
Subject: A lot of flush requests to the backing device
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Fri, 05 Nov 2021 14:21:19 +0300
Message-Id: <10612571636111279@vla5-f98fea902492.qloud-c.yandex.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi all,
 
I've used bcache a lot for the last three years, mostly in writeback mode with ceph, and I faced a strange behavior. When there's a heavy write load on the bcache device with a lot of fsync()/fdatasync() requests, the bcache device issues a lot of flush requests to the backing device. If the writeback rate is low, then there might be hundreds of flush requests per second issued to the backing device.
 
If the writeback rate growths, then latency of the flush requests increases. And latency of the bcache device increases as a result and the application experiences higher disk latency. So, this behavior of bcache slows the application in it's I/O requests when writeback rate becomes high.
 
This workload pattern with a lot of fsync()/fdatasync() requests is a common for a latency-sensitive applications. And it seems that this bcache behavior slows down this type of workloads.
 
As I understand, if a write request with REQ_PREFLUSH is issued to bcache device, then bcache issues new empty write request with REQ_PREFLUSH to the backing device. What is the purpose of this behavior? It looks like it might be eliminated for the better performance.

--
Regards,
Aleksei Zakharov
alexzzz.ru
