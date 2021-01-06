Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213982EC2B7
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Jan 2021 18:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbhAFRt7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Wed, 6 Jan 2021 12:49:59 -0500
Received: from mail.eclipso.de ([217.69.254.104]:49926 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbhAFRt7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Jan 2021 12:49:59 -0500
Received: from mail.eclipso.de (www1.eclipso.de [217.69.254.102])
        by mail.eclipso.de with ESMTP id 7CC49F43
        for <linux-bcache@vger.kernel.org>; Wed, 06 Jan 2021 18:49:17 +0100 (CET)
Date:   Wed, 06 Jan 2021 18:49:17 +0100
MIME-Version: 1.0
Message-ID: <dd5369f020d6d2209c8a4f19dc94340f@mail.eclipso.de>
X-Mailer: eclipso / 7.4.0
From:   " " <Cedric.dewijs@eclipso.eu>
Subject: script to disable writeback when a drive is idle
Reply-To: " " <Cedric.dewijs@eclipso.eu>
To:     <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi all,

I have two stacks of a HDD with a bcache SSD in front of it in writeback mode. I have made the following quick and dirty script to disable writeback when the HDD is in standby. I hope it helps somebody:

# cat writeback.sh
#!/bin/bash

function sdbGetState()
{
        hdparmstr=$(hdparm -C /dev/sdb | grep drive)
    echo $hdparmstr
}

function sddGetState()
{
        hdparmstr=$(hdparm -C /dev/sdd | grep drive)
        echo $hdparmstr
}

strSdb=$(sdbGetState)
echo $strSdb

strSdd=$(sddGetState)
echo $strSdd


if [ "$strSdd" = 'drive state is: active/idle' ];
then
    echo 1 > /sys/block/bcache0/bcache/writeback_running
    echo active
else
    echo 0 > /sys/block/bcache0/bcache/writeback_running
    echo idle
fi

if [ "$strSdb" = 'drive state is: active/idle' ];
then
        echo 1 > /sys/block/bcache1/bcache/writeback_running
        echo active
else
        echo 0 > /sys/block/bcache1/bcache/writeback_running
        echo idle
fi

---

Take your mailboxes with you. Free, fast and secure Mail &amp; Cloud: https://www.eclipso.eu - Time to change!


