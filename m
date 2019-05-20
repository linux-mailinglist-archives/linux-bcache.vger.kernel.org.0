Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A08924177
	for <lists+linux-bcache@lfdr.de>; Mon, 20 May 2019 21:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfETTsk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 20 May 2019 15:48:40 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42886 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfETTsk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 20 May 2019 15:48:40 -0400
Received: by mail-qt1-f193.google.com with SMTP id j53so17730926qta.9
        for <linux-bcache@vger.kernel.org>; Mon, 20 May 2019 12:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=qMQw7dNholpnfslEfrwNSWbzt2upS5e6SPivGOkCxhk=;
        b=jdRgf+irMP+W7IGgRTIPuQac73dyfg26C7DRQ0uKIQafY6Bit5aCKH/7cA8fW2+r7t
         WKxzVZxbpbBPFOo4jlvyl50Cr3ejqKwA/m6fS0O1DDHYxJ13ZpC77PQAjNAlpXlWNuNc
         0iD/HSN3R3DAiALa4EBDq1hlk0t7SANvqsEPQd9YunH8jgS+r4hJxma0QCOEOizrqebX
         3tZndjITCkOnVh+0vBLzlK5YlSEyuwjexMslnRGd+BjLwmPkfPQZmQLttAUpxbZawAV0
         X3sx722BfoDSBaegdCSgcnjTL2saTT/BwfjROhvLGIsYGrFzaZVFOZzYknTlV5K2hdQ0
         fptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=qMQw7dNholpnfslEfrwNSWbzt2upS5e6SPivGOkCxhk=;
        b=AMOjgevcH7ydjRCF6r59BJWlca4vhYcitAyzjFT43PIrNxUZFibz29yDiNgwP5NYDx
         svgfgw3qRdJKl7c2eyvT3teC1VZeUZGxnq98tRdkxuO81pkhdxCfyfC8YLeyRM6xBE8C
         iFMZ2AF73UOX2EGW+DbNr6C1EHlCuyUTq/xx7L9wAHYohqK1m5+CrFp5puyvmhqBb57i
         62lzw72mieGsWpZCcn+nNdjL+4kQZq23s/PuYihonPDFeFpBz+M6A8I4G2qP/HqRkSBn
         Ti6qCvaO4gFISsh3h2r0id6qFrroWDS8oeaES7rXq/GZ2iiLlpxqT0y7znQaSGUyVPDW
         20YA==
X-Gm-Message-State: APjAAAVfjAlKP46sTWnherYicBW2S8kPHeB3dFe7bz+nQHobT9v2Vooc
        2Jf2UUVVRfiMbysymwnV8DlL0SuyG9P04mQ3Y2SRxBdi
X-Google-Smtp-Source: APXvYqyu0D7+d1GAETgCH5aeL+x1ai45adqLX44oeCb3NY02EQC0bIImuCKQ9ZximFksIOgNgJIqDYT2Hw3TKU1qnvE=
X-Received: by 2002:a0c:b5c5:: with SMTP id o5mr2877290qvf.6.1558381718933;
 Mon, 20 May 2019 12:48:38 -0700 (PDT)
MIME-Version: 1.0
From:   Ivan Babrou <ibobrik@gmail.com>
Date:   Mon, 20 May 2019 12:48:13 -0700
Message-ID: <CANWdNRBxVOxk6ysgHcHzSDVfZ0jLeL26uZHmfS+nqkkf22Gbjw@mail.gmail.com>
Subject: In-memory bcache
To:     linux-bcache@vger.kernel.org
Cc:     colyli@suse.de, kent.overstreet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hey,

I'm trying to replicate Flashield for a filesystem with bcache:

* https://www.usenix.org/conference/nsdi19/presentation/eisenman

I have a filesystem on SSD with lots of tiny cache files and my goal is to:

* Not write files that are going to be overwritten (low TTL for example)
* If I end up writing, I want to write in large chunks to reduce write
amplification

These two things combined should greatly reduce durability requirements for SSD.

Is it possible to achieve with bcache? I can live without durability.

So far I've tried:

* Storage on SSD
* Cache on /dev/ram0
* Disabled sequential cutoff
* Enabled writeback
* Put ext4 without a journal on /dev/bache0

But it seems like some writes still spill directly onto durable
storage, dd of 10MB of zeros reliably generates IO almost immediately
(before writeback delay), which I am trying to avoid in the first
place.

I have a fuse implementation of what I want to do, but was hoping to
get away with what is available out of the box.

Thanks!
