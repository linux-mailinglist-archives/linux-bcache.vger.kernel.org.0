Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259287438FF
	for <lists+linux-bcache@lfdr.de>; Fri, 30 Jun 2023 12:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbjF3KJZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 30 Jun 2023 06:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbjF3KJN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Jun 2023 06:09:13 -0400
Received: from mail.eclipso.de (mail.eclipso.de [217.69.254.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF704488
        for <linux-bcache@vger.kernel.org>; Fri, 30 Jun 2023 03:08:53 -0700 (PDT)
Received: from mail.eclipso.de (www1.eclipso.de [217.69.254.102])
        by mail.eclipso.de with ESMTP id 1C2E84AE
        for <linux-bcache@vger.kernel.org>; Fri, 30 Jun 2023 12:08:52 +0200 (CEST)
Date:   Fri, 30 Jun 2023 12:08:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eclipso.de; s=mail;
        t=1688119732; bh=xyXa+jEU8T/PxaLbv0ql+m2+2eRMm5HUMtLv08hmQTs=;
        h=Date:From:Subject:Reply-To:To:From;
        b=XeWNRrLp5QAJv1E3LkX1RQKnZCcFlWL42ZxHX47Xb4KwuhAI0Tx2XfeQuzys9UNki
         1pbEZFO/SqXkwq3UKbZ18+Opun8E0EX4nu60E/pAVrasolfFkJbzZPo+pA5p6gcrc6
         YwIb/TXbC936UKomxndBqxIJpvtWALewhQHrJC1bhoHO0xUplbscEIUUKIKNnoLEtc
         YOmxfaOR2nEYeldb5tajeF0H3xZ3llWDLgGavZGhlV/+3gIMPTuxK89kvpfox+32YE
         kAC3ylLkZDO7DWdeUyk8U6R8C2amgVK1cr1grboq8haWMUTVWhH4uiblVlhIMU30gx
         v+Ub1zH9FW/tQ==
MIME-Version: 1.0
Message-ID: <1be1562c9792cf8c036e4c7485047fd3@mail.eclipso.de>
X-Mailer: eclipso / 7.4.0
From:   " " <Cedric.dewijs@eclipso.eu>
Subject: configure bcache for preventing IO to a HDD to save power / noise
Reply-To: " " <Cedric.dewijs@eclipso.eu>
To:     <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FROMSPACE,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

=C2=ADI have 4 HDD's, and 4 SSD's. Each HDD is cached by it's own SSD. The =
4 HDD/SSD stacks are used to create a btrfs raid system as described here:
https://wiki.archlinux.org/title/Bcache#Situation:_3_hard_drives_and_3_read=
/write_cache_SSD's

I want the hard drives to stay idle, so they don't spin, don't consume powe=
r and be silent.

I would like to configure bcache like this:
1) Never write to the hard drive, unless there's (almost) no room on the SS=
D anymore.
2) Avoid reading from the HDD, so cache everything that has been read from =
the HDD.
3) When a cache miss occurs, wake up the HDD, and read from there.=20
4) After a cache miss, write all the dirty data from the SSD to the HDD unt=
il there's no dirty data anymore.
5) When both reading and writing data to the HDD, prioritize reading.

i've tried these settings to avoid write access to the HDD:
echo 0 >  /sys/fs/bcache/<uuid>/congested_read_threshold_us=20
echo 0 >  /sys/fs/bcache/<uuid>/congested_write_threshold_us=20
echo writeback > /sys/block/bcache3/bcache/cache_mode
echo 0 >  /sys/block/bcache0/bcache/sequential_cutoff=20
With the above settings, all the writes first go to the SSD's, but then the=
y are almost immediately flushed into the HDD.

echo 90 > /sys/block/bcache0/bcache/writeback_percent
With this setting I hoped the writes to the HDD would stop until the SSD wa=
s almost full. This percentage is clipped to 40%, so most of the SSD can't =
be used as a write cache. Also there were still writes into the HDD:
# cat /sys/block/bcache0/bcache/writeback_percent
40

With this setting I don't see writes to the HDD anymore: What happens when =
the amount of dirty data is over 40% while the delay has not yet expired?
echo 100000 > /sys/block/bcache0/bcache/writeback_delay

How can I configure bcache so the HDD's are idle for as long as possible?


________________________________________________________
Your E-Mail. Your Cloud. Your Office. eclipso Mail & Cloud. https://www.ecl=
ipso.eu


